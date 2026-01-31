import SwiftUI
import Domain
import DesignSystem

struct MyPostCard: View {
    let post: Post
    var showsHeart: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                if let artworkUrl = post.artworkUrl {
                    AsyncImage(url: URL(string: artworkUrl)) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.2)
                                .aspectRatio(1, contentMode: .fill)
                                .overlay {
                                    ProgressView()
                                }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                        case .failure:
                            Color.gray.opacity(0.2)
                                .aspectRatio(1, contentMode: .fill)
                                .overlay {
                                    Image(systemName: "music.note")
                                        .foregroundColor(.gray)
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Color.gray.opacity(0.2)
                        .aspectRatio(1, contentMode: .fill)
                        .overlay {
                            Image(systemName: "music.note")
                                .foregroundColor(.gray)
                        }
                }

            }
            .cornerRadius(12)
            .clipped()

            HStack(spacing: 6) {
                Text(post.title ?? "제목 없음")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                    .lineLimit(1)

                Spacer(minLength: 0)

                if showsHeart {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.accentPrimary)
                }
            }

            HStack(alignment: .center, spacing: 4) {
                if let songName = post.songName, !songName.isEmpty {
                    Text(songName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(1)
                }

                if let artistName = post.artistName, !artistName.isEmpty {
                    Text(artistName)
                        .font(.system(size: 11))
                        .foregroundColor(Color.textFootnote)
                        .lineLimit(1)
                }
                Spacer()
            }
        }
        .background(Color.mainBackground)
        .cornerRadius(12)
    }
}
