import SwiftUI
import Domain
import DesignSystem
import PostDetailInterface

struct PostDetailView: View {
    @StateObject private var viewModel: PostDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCommentsList: Bool = false
    @State private var isNavigatingToSearch: Bool = false
    @State private var commentText: String = ""
    @State private var showPostActionSheet: Bool = false
    @State private var isShowingEditSheet: Bool = false
    @FocusState private var isCommentFocused: Bool

    init(viewModel: PostDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        if let detail = viewModel.postDetail {
                            PostDetailContent(
                                detail: detail,
                                isPlaying: viewModel.isPlaying,
                                onTogglePlay: {
                                    viewModel.togglePlay()
                                },
                                isShowingCommentsList: showCommentsList,
                                onToggleCommentsList: {
                                    showCommentsList.toggle()
                                }
                            )
                            .padding(.bottom, 40)
                        } else {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 400)
                        }
                    }
                }

                CommentInputBar(
                    commentText: $commentText,
                    isCommentFocused: _isCommentFocused,
                    selectedMusicTitle: viewModel.selectedMusicDisplayText,
                    selectedMusicArtworkURL: viewModel.selectedMusic?.artworkUrl,
                    onTapAddMusic: {
                        openMusicSearch()
                    },
                    onSend: {
                        let trimmed = commentText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        Task {
                            await viewModel.createComment(content: trimmed)
                            await MainActor.run {
                                commentText = ""
                            }
                        }
                    },
                    onRemoveMusic: {
                        viewModel.clearSelectedMusic()
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("home")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isMyPost {
                    Button {
                        showPostActionSheet = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .disabled(viewModel.isManagingPost)
                } else {
                    Button {
                        viewModel.toggleLike()
                    } label: {
                        Image(viewModel.postDetail?.isLiked == true ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    .disabled(viewModel.isUpdatingLike)
                }
            }
        }
        .onAppear {
            viewModel.loadPostDetail()
        }
        .onChange(of: viewModel.didDeletePost) { didDelete in
            if didDelete {
                dismiss()
            }
        }
        .sheet(isPresented: $showPostActionSheet) {
            PostActionSheetView(
                isProcessing: viewModel.isManagingPost,
                onEdit: {
                    if viewModel.postDetail != nil {
                        isShowingEditSheet = true
                    }
                    showPostActionSheet = false
                },
                onComplete: {
                    showPostActionSheet = false
                    viewModel.markPostCompleted()
                },
                onDelete: {
                    showPostActionSheet = false
                    viewModel.deletePost()
                }
            )
            .presentationDetents([.fraction(1.0/3.0)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingEditSheet) {
            if let detail = viewModel.postDetail {
                PostEditSheet(viewModel: viewModel, detail: detail)
            } else {
                EmptyView()
            }
        }
        .background(navigationLink)
    }

    private struct PostDetailContent: View {
        let detail: PostDetail
        let isPlaying: Bool
        let onTogglePlay: () -> Void
        let isShowingCommentsList: Bool
        let onToggleCommentsList: () -> Void

        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    AsyncImage(url: URL(string: detail.artworkUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: UIScreen.main.bounds.width - 48, height: UIScreen.main.bounds.width - 48)
                    .clipped()

                    Button(action: onTogglePlay) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)

                HStack {
                    Text(detail.songName)
                        .font(.pretendard(size: 20, weight: .semiBold))
                        .foregroundColor(.accentPrimary)

                    Spacer()

                    Text(detail.artistName)
                        .font(.pretendard(size: 12, weight: .regular))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Text(detail.title)
                    .font(.pretendard(size: 18, weight: .semiBold))
                    .foregroundColor(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                Text(detail.content)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundColor(Color.textPrimary)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                Button(action: onToggleCommentsList) {
                    HStack {
                        Image("list")
                            .font(.system(size: 16))
                        Text(isShowingCommentsList ? "카드보기" : "글보기")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                if let comments = detail.comments, !comments.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        if isShowingCommentsList {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(comments, id: \.commentId) { comment in
                                    CommentListItem(comment: comment)
                                }
                            }
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(comments, id: \.commentId) { comment in
                                    CommentCard(comment: comment)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    private var navigationLink: some View {
        NavigationLink(isActive: $isNavigatingToSearch) {
            viewModel.makeMusicSearchView()
        } label: {
            EmptyView()
        }
        .hidden()
    }

    private func openMusicSearch() {
        isNavigatingToSearch = true
    }
}
