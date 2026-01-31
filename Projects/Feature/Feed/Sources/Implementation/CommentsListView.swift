import SwiftUI
import DesignSystem
import PostDetailInterface
import Domain

public struct CommentsListView: View {
    @ObservedObject var viewModel: FeedViewModel
    private let postDetailBuilder: PostDetailBuildable

    public init(viewModel: FeedViewModel, postDetailBuilder: PostDetailBuildable) {
        _viewModel = ObservedObject(initialValue: viewModel)
        self.postDetailBuilder = postDetailBuilder
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                InboxHeaderView(
                    title: "Comments",
                    count: viewModel.commentedPosts.count,
                    description: "참여한 사연과 플레이리스트입니다."
                )
               

                if viewModel.commentedPosts.isEmpty && !viewModel.isLoadingCommentedPosts {
                    EmptyInboxListView(message: "댓글을 남긴 사연이 없습니다")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                } else {
                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.commentedPosts.enumerated()), id: \.offset) { _, post in
                            if let postId = post.postId {
                                NavigationLink {
                                    postDetailBuilder.makePostDetailView(postId: postId)
                                } label: {
                                    CommentedPostRow(post: post)
                                }
                                .buttonStyle(.plain)
                            } else {
                                CommentedPostRow(post: post)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .background(Color.mainBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.commentedPosts.isEmpty {
                viewModel.loadCommentedPosts()
            }
        }
    }
}

private struct CommentedPostRow: View {
    let post: Post

    var body: some View {
        HStack(spacing: 12) {
            if let artworkUrl = post.artworkUrl, let url = URL(string: artworkUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Color.gray.opacity(0.15)
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(post.title ?? "사연 제목")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Text("참여한 사연과 플레이리스트입니다.")
                    .font(.system(size: 12))
                    .foregroundColor(.textFootnote)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.textFootnote)
        }
        .padding(16)
        .background(Color.contentBackground)
        .cornerRadius(16)
    }
}
