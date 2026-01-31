import SwiftUI
import Domain
import DesignSystem

struct CommentSheet: View {
    @ObservedObject var viewModel: PostDetailViewModel
    let onTapAddMusic: () -> Void
    @State private var commentText: String = ""
    @FocusState private var isCommentFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    if let comments = viewModel.postDetail?.comments {
                        ForEach(comments, id: \.commentId) { comment in
                            CommentListItem(comment: comment)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }

            CommentInputBar(
                commentText: $commentText,
                isCommentFocused: _isCommentFocused,
                selectedMusicTitle: viewModel.selectedMusicDisplayText,
                selectedMusicArtworkURL: viewModel.selectedMusic?.artworkUrl,
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
    }
}

struct CommentListItem: View {
    let comment: Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                if let artworkUrl = comment.artworkUrl, let url = URL(string: artworkUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    ZStack {
                        Color.gray.opacity(0.15)
                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(comment.songName ?? "제목 없음")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)

                    Text(artistDescription)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                Button {
                    // Play/Pause action
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }

            if let content = comment.content {
                Text(content)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineSpacing(4)
            }

            Divider()
                .padding(.top, 4)
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
                    // Play action
                } label: {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.black.opacity(0.7))
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
    }
}
