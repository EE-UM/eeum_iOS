import SwiftUI
import Domain
import DesignSystem
import PostDetailInterface

struct DoneGridView: View {
    let posts: [Post]
    let postDetailBuilder: PostDetailBuildable
    let onLoadMore: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            if posts.isEmpty {
                EmptyDoneView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Array(posts.enumerated()), id: \.element.postId) { index, post in
                        DonePostCard(post: post, index: index + 1, total: posts.count, postDetailBuilder: postDetailBuilder)
                            .onAppear {
                                // Load more when approaching end
                                if index >= posts.count - 4 {
                                    onLoadMore()
                                }
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
}

struct DonePostCard: View {
    let post: Post
    let index: Int
    let total: Int
    let postDetailBuilder: PostDetailBuildable

    var body: some View {
        if let postId = post.postId {
            NavigationLink {
                postDetailBuilder.makePostDetailView(postId: postId, source: .feed)
            } label: {
                DonePostCardContent(post: post, index: index, total: total)
            }
        } else {
            DonePostCardContent(post: post, index: index, total: total)
        }
    }
}

struct DonePostCardContent: View {
    let post: Post
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Thumbnail with counter overlay
            ZStack(alignment: .bottomTrailing) {
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

                // Counter badge
                Text("\(index)/\(total)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.7))
                    )
                    .padding(8)
            }
            .cornerRadius(12)
            .clipped()

            // 사연 제목
            Text(post.title ?? "제목 없음")
                .font(.pretendard(size: 14, weight: .medium))
                .foregroundColor(Color.textPrimary)
                .lineLimit(1)
                .padding(.top, 8)
                .padding(.horizontal, 4)

            // 곡 이름 + 가수 이름
            HStack(spacing: 4) {
                if let songName = post.songName {
                    Text(songName)
                        .font(.pretendard(size: 12, weight: .regular))
                        .foregroundColor(Color.textPrimary)
                        .lineLimit(1)
                }
                if let artistName = post.artistName {
                    Text(artistName)
                        .font(.pretendard(size: 12, weight: .regular))
                        .foregroundColor(Color.textFootnote)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(Color.clear)
        .cornerRadius(12)
    }
}

struct EmptyDoneView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))

            Text("완료된 사연이 없습니다")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.textFootnote)
        }
    }
}
