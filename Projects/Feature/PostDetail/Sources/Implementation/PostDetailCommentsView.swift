import SwiftUI
import Domain
import DesignSystem

struct CommentSheet: View {
    @ObservedObject var viewModel: PostDetailViewModel
    let onTapAddMusic: () -> Void
    var onLongPressComment: ((Comment) -> Void)? = nil
    @State private var commentText: String = ""
    @FocusState private var isCommentFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let comments = viewModel.postDetail?.comments {
                    ForEach(comments, id: \.commentId) { comment in
                        CommentListItem(
                            comment: comment,
                            isPlaying: viewModel.isPlaying(url: comment.appleMusicUrl ?? ""),
                            onPlay: {
                                if let url = comment.appleMusicUrl {
                                    viewModel.playComment(url: url)
                                }
                            },
                            onLongPress: {
                                onLongPressComment?(comment)
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
        }
        .safeAreaInset(edge: .bottom) {
            SheetCommentInputBar(
                commentText: $commentText,
                isCommentFocused: _isCommentFocused,
                selectedMusicTitle: viewModel.selectedMusicDisplayText,
                selectedMusicArtworkURL: viewModel.selectedMusic?.artworkUrl,
                selectedMusicSongName: viewModel.selectedMusic?.songName,
                selectedMusicArtistName: viewModel.selectedMusic?.artistName,
                onTapAddMusic: onTapAddMusic,
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
        .background(Color.mainBackground)
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                isCommentFocused = true
            }
        }
    }
}

struct CommentListItem: View {
    let comment: Comment
    var isPlaying: Bool = false
    var onPlay: (() -> Void)? = nil
    var onLongPress: (() -> Void)? = nil

    private static let pillBackground = Color(red: 234/255, green: 232/255, blue: 224/255)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // ♪ 아이콘 + 캡슐(곡 제목 + 아티스트 + 재생 버튼)
            HStack(spacing: 8) {
                Image("Musicnote")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)

                HStack(spacing: 8) {
                    Text(comment.songName ?? "제목 없음")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Text(artistDescription)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)

                    Button {
                        onPlay?()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Self.pillBackground)
                .clipShape(Capsule())
            }

            // 댓글 내용
            if let content = comment.content, !content.isEmpty {
                Text(content)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineSpacing(5)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onLongPressGesture {
            onLongPress?()
        }
    }

    private var artistDescription: String {
        guard let artistName = comment.artistName, !artistName.isEmpty else {
            return "아티스트 미상"
        }
        return artistName
    }
}

struct CommentCard: View {
    let comment: Comment
    var isPlaying: Bool = false
    var onPlay: (() -> Void)? = nil
    var onLongPress: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let artworkUrl = comment.artworkUrl {
                    AsyncImage(url: URL(string: artworkUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(height: 150)
                    .clipped()
                } else {
                    Color.gray.opacity(0.2)
                        .frame(height: 150)
                }

                Button {
                    onPlay?()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
            }
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                if let songName = comment.songName {
                    Text(songName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                }

                if let artistName = comment.artistName {
                    Text(artistName)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
        }
        .contentShape(Rectangle())
        .onLongPressGesture {
            onLongPress?()
        }
    }
}
