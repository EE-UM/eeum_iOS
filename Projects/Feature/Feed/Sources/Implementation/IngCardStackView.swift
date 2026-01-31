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
                    StackedCarousel(
                        posts: $posts,
                        activePostId: $currentPostId,
                        postDetailBuilder: postDetailBuilder,
                        onLoadMore: onSwipe
                    )
                    .padding(.top, 4)

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

            // View 버튼 - 하단 고정
            if let post = currentPost, let postId = post.postId {
                NavigationLink {
                    postDetailBuilder.makePostDetailView(postId: postId)
                } label: {
                    Text("View")
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

struct StackedCarousel: View {
    @Binding var posts: [Post]
    @Binding var activePostId: String?
    let postDetailBuilder: PostDetailBuildable
    let onLoadMore: () -> Void

    private let maxImageSide: CGFloat = 280
    private let spacing: CGFloat = 16

    private var postIdentifiers: [String] {
        posts.enumerated().map { "\($0.offset)-\($0.element.postId ?? "nil")" }
    }

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = max(geometry.size.width - 48, 220)
            let tentativeWidth = availableWidth * 0.85
            let cardWidth = max(220, min(maxImageSide, tentativeWidth))
            let horizontalPadding = max(0, (geometry.size.width - cardWidth) / 2)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(Array(posts.enumerated()), id: \.offset) { entry in
                        if let cardId = entry.element.postId {
                            carouselCard(
                                for: entry.element,
                                id: cardId,
                                containerWidth: geometry.size.width,
                                cardWidth: cardWidth
                            )
                            .frame(width: cardWidth)
                            .id(cardId)
                        }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, horizontalPadding)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activePostId, anchor: .center)
            .onAppear(perform: configureInitialSelection)
            .onChange(of: postIdentifiers) { _ in
                syncSelectionWithPosts()
            }
            .onChange(of: activePostId) { newValue in
                guard let newValue, let index = posts.firstIndex(where: { $0.postId == newValue }) else { return }
                if index >= posts.count - 2 {
                    onLoadMore()
                }
            }
            .frame(height: cardWidth + 60)
        }
        .frame(maxHeight: maxImageSide + 60)
    }

    @ViewBuilder
    private func carouselCard(for post: Post, id: String, containerWidth: CGFloat, cardWidth: CGFloat) -> some View {
        GeometryReader { geometryProxy in
            let normalized = normalizedDelta(for: geometryProxy, containerWidth: containerWidth)

            ZStack(alignment: .topTrailing) {
                // 이미지
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
                .frame(width: cardWidth, height: cardWidth)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )

                // 일시정지 버튼
                Button(action: {
                    // TODO: 재생/일시정지 로직
                }) {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "pause.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        )
                }
                .padding(.top, 24)
                .padding(.trailing, 24)
            }
            .frame(width: cardWidth, height: cardWidth)
            .onTapGesture {
                // NavigationLink로 이동하는 동작은 여기서 처리 필요시 추가
            }
            .shadow(color: Color.black.opacity(0.18 * normalized), radius: 18, x: 0, y: 12)
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(scale(for: normalized))
            .opacity(opacity(for: normalized))
            .zIndex(Double(normalized))
            .offset(y: yOffset(for: normalized))
        }
        .frame(height: cardWidth)
    }

    private func configureInitialSelection() {
        guard !posts.isEmpty else {
            activePostId = nil
            return
        }

        let index = currentActiveIndex() ?? 0
        updateActivePost(for: index)
    }

    private func syncSelectionWithPosts() {
        guard !posts.isEmpty else {
            activePostId = nil
            return
        }

        let index = currentActiveIndex() ?? 0
        updateActivePost(for: index)
    }

    private func updateActivePost(for index: Int) {
        guard posts.indices.contains(index) else { return }
        if let id = posts[index].postId {
            activePostId = id
        }

        if index >= posts.count - 2 {
            onLoadMore()
        }
    }

    private func currentActiveIndex() -> Int? {
        guard let targetId = activePostId ?? posts.first?.postId else { return nil }
        return posts.firstIndex { $0.postId == targetId }
    }

    private func normalizedDelta(for geometryProxy: GeometryProxy, containerWidth: CGFloat) -> CGFloat {
        let frame = geometryProxy.frame(in: .global)
        let centerX = containerWidth / 2
        let delta = frame.midX - centerX
        let normalized = 1 - min(1, abs(delta / centerX))
        return max(0, normalized)
    }

    private func scale(for normalized: CGFloat) -> CGFloat {
        0.8 + normalized * 0.35
    }

    private func opacity(for normalized: CGFloat) -> Double {
        Double(0.5 + normalized * 0.5)
    }

    private func yOffset(for normalized: CGFloat) -> CGFloat {
        let maxLift: CGFloat = 20
        return (1 - normalized) * maxLift
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
