import SwiftUI
import Domain
import DesignSystem
import PostDetailInterface

struct IngCardStackView: View {
    @Binding var posts: [Post]
    @Binding var currentPostId: String?
    let postDetailBuilder: PostDetailBuildable
    let onSwipe: () -> Void

    private var postIdentifiers: [String] {
        posts.enumerated().map { "\($0.offset)-\($0.element.postId ?? "nil")" }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                if posts.isEmpty {
                    EmptyIngView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    IngPagerView(
                        posts: $posts,
                        activePostId: $currentPostId,
                        onLoadMore: onSwipe
                    )

                    if let post = currentPost {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(post.title ?? "제목 없음")
                                .font(.pretendard(size: 18, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)

                            if let content = post.content {
                                Text(content)
                                    .font(.pretendard(size: 14, weight: .regular))
                                    .foregroundColor(.textFootnote)
                                    .lineLimit(4)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }

                    Spacer(minLength: 0)
                }
            }

            if let post = currentPost, let postId = post.postId {
                NavigationLink {
                    postDetailBuilder.makePostDetailView(postId: postId, source: .feed)
                } label: {
                    Text("view")
                        .font(.pretendard(size: 16, weight: .semiBold))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 39)
            }
        }
        .onAppear(perform: syncCurrentPostSelection)
        .onChange(of: postIdentifiers) { _ in
            syncCurrentPostSelection()
        }
    }

    private func syncCurrentPostSelection() {
        guard !posts.isEmpty else {
            if currentPostId != nil {
                currentPostId = nil
            }
            return
        }

        if let selectedId = currentPostId {
            let stillExists = posts.contains { $0.postId == selectedId }
            if !stillExists {
                currentPostId = posts.first?.postId
            }
        } else {
            currentPostId = posts.first?.postId
        }
    }

    private var currentPost: Post? {
        if let id = currentPostId {
            return posts.first(where: { $0.postId == id })
        }
        return posts.first
    }
}

// MARK: - Pager

private struct IngPagerView: View {
    @Binding var posts: [Post]
    @Binding var activePostId: String?
    let onLoadMore: () -> Void
    @ObservedObject private var audioPlayer = AudioPlayerService.shared

    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width - 80
            let cardHeight = cardWidth
            let leadingPadding = CGFloat(24)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(Array(posts.enumerated()), id: \.offset) { _, post in
                        if let cardId = post.postId {
                            pagerCard(post: post, cardWidth: cardWidth, cardHeight: cardHeight)
                                .frame(width: cardWidth)
                                .id(cardId)
                        }
                    }
                }
                .scrollTargetLayout()
                .padding(.leading, leadingPadding)
                .padding(.trailing, 56)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activePostId, anchor: .leading)
            .onChange(of: activePostId) { newValue in
                guard let newValue, let index = posts.firstIndex(where: { $0.postId == newValue }) else { return }
                if index >= posts.count - 2 {
                    onLoadMore()
                }
            }
            .frame(height: cardHeight)
        }
        .frame(height: UIScreen.main.bounds.width - 80)
    }

    @ViewBuilder
    private func pagerCard(post: Post, cardWidth: CGFloat, cardHeight: CGFloat) -> some View {
        ZStack(alignment: .bottomLeading) {
            // Artwork
            AsyncImage(url: URL(string: post.artworkUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 4))

            // Play/Pause button
            Button {
                if let url = post.appleMusicUrl, !url.isEmpty {
                    audioPlayer.toggle(url: url)
                }
            } label: {
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: audioPlayer.isCurrentlyPlaying(url: post.appleMusicUrl ?? "") ? "pause.fill" : "play.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    )
            }
            .buttonStyle(.plain)
            .padding(.leading, 12)
            .padding(.bottom, 12)
        }
    }
}

struct EmptyIngView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))

            Text("진행 중인 사연이 없습니다")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.textFootnote)
        }
    }
}
