import SwiftUI
import Domain
import DesignSystem

struct FeedCardView: View {
    let post: Post
    @State private var isPlaying: Bool = false
    @State private var isLiked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text(post.title ?? "제목 없음")
                .font(.pretendard(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
                .lineLimit(2)

            // Content
            if let content = post.content {
                Text(content)
                    .font(.pretendard(size: 15, weight: .regular))
                    .foregroundColor(.textFootnote)
                    .lineLimit(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            // Music Player Section
            HStack(spacing: 12) {
                // Album Art
                if let artworkUrl = post.artworkUrl {
                    AsyncImage(url: URL(string: artworkUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        default:
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }

                // Song Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.songName ?? "음악 정보 없음")
                        .font(.pretendard(size: 16, weight: .semiBold))
                        .foregroundColor(.textPrimary)
                    Text(post.artistName ?? "")
                        .font(.pretendard(size: 14, weight: .regular))
                        .foregroundColor(.textFootnote)
                }

                Spacer()

                // Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        isPlaying.toggle()
                    }) {
                        Image(isPlaying ? "pause" : "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.textPrimary)
                    }

                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(isLiked ? .accentPrimary : .textPrimary)
                    }
                }
            }
            .padding(12)
            .background(Color.contentBackground.opacity(0.5))
            .cornerRadius(12)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}
