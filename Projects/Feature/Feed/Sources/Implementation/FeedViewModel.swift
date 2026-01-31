import Foundation
import Combine
import SwiftUI
import Domain

public enum FeedTab {
    case ing
    case done
}

public final class FeedViewModel: ObservableObject {
    @Published var selectedTab: FeedTab = .ing
    @Published var ingPosts: [Post] = []
    @Published var donePosts: [Post] = []
    @Published var myPosts: [Post] = []
    @Published var likedPosts: [Post] = []
    @Published var commentedPosts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingLikedPosts: Bool = false
    @Published var isLoadingCommentedPosts: Bool = false
    @Published var errorMessage: String?

    // For pagination
    @Published var lastIngPostId: Int64?
    @Published var lastDonePostId: Int64?
    @Published var hasMoreIngPosts: Bool = true
    @Published var hasMoreDonePosts: Bool = true

    // For card swipe state in Ing tab
    @Published var currentCardPostId: String?

    private let postRepository: PostRepository
    private var notificationTokens: [NSObjectProtocol] = []
    private let pageSize: Int64 = 20

    public init(postRepository: PostRepository) {
        self.postRepository = postRepository
        observePostNotifications()
    }

    deinit {
        notificationTokens.forEach { NotificationCenter.default.removeObserver($0) }
    }

    @MainActor
    func loadIngPosts() {
        guard !isLoading && hasMoreIngPosts else { return }

        isLoading = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }
            do {
                let posts = try await postRepository.getIngPosts(
                    pageSize: pageSize,
                    lastPostId: lastIngPostId
                )

                await MainActor.run {
                    if posts.isEmpty {
                        self.hasMoreIngPosts = false
                    } else {
                        // 중복 제거: 기존 postId와 겹치지 않는 항목만 추가
                        let existingIds = Set(self.ingPosts.compactMap { $0.postId })
                        let newPosts = posts.filter { post in
                            guard let postId = post.postId else { return false }
                            return !existingIds.contains(postId)
                        }

                        self.ingPosts.append(contentsOf: newPosts)

                        if let lastPost = posts.last,
                           let postIdString = lastPost.postId,
                           let postIdInt = Int64(postIdString) {
                            self.lastIngPostId = postIdInt
                        }
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    @MainActor
    func loadDonePosts() {
        guard !isLoading && hasMoreDonePosts else { return }

        isLoading = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }
            do {
                let posts = try await postRepository.getDonePosts(
                    pageSize: pageSize,
                    lastPostId: lastDonePostId
                )

                await MainActor.run {
                    if posts.isEmpty {
                        self.hasMoreDonePosts = false
                    } else {
                        // 중복 제거: 기존 postId와 겹치지 않는 항목만 추가
                        let existingIds = Set(self.donePosts.compactMap { $0.postId })
                        let newPosts = posts.filter { post in
                            guard let postId = post.postId else { return false }
                            return !existingIds.contains(postId)
                        }

                        self.donePosts.append(contentsOf: newPosts)

                        if let lastPost = posts.last,
                           let postIdString = lastPost.postId,
                           let postIdInt = Int64(postIdString) {
                            self.lastDonePostId = postIdInt
                        }
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    @MainActor
    func refreshData() {
        // Reset pagination
        lastIngPostId = nil
        lastDonePostId = nil
        hasMoreIngPosts = true
        hasMoreDonePosts = true
        ingPosts = []
        donePosts = []
        currentCardPostId = nil

        // Load fresh data
        if selectedTab == .ing {
            loadIngPosts()
        } else {
            loadDonePosts()
        }
    }

    private func observePostNotifications() {
        let updateToken = NotificationCenter.default.addObserver(
            forName: .postDidUpdate,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handlePostUpdateNotification(notification)
        }
        notificationTokens.append(updateToken)
    }

    @MainActor
    private func handlePostUpdateNotification(_ notification: Notification) {
        guard
            let rawAction = notification.userInfo?["action"] as? String,
            let action = PostUpdateAction(rawValue: rawAction),
            let postId = notification.userInfo?["postId"] as? String
        else { return }

        removePostFromLists(postId: postId)

        switch action {
        case .completed:
            refreshData()
            refreshMyPostsFromServer()
        case .deleted:
            refreshMyPostsFromServer()
        }
    }

    @MainActor
    private func removePostFromLists(postId: String) {
        ingPosts.removeAll { $0.postId == postId }
        donePosts.removeAll { $0.postId == postId }
        myPosts.removeAll { $0.postId == postId }
    }

    private func refreshMyPostsFromServer() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let posts = try await postRepository.getMyPosts()
                await MainActor.run {
                    self.myPosts = posts
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    @MainActor
    func swipeToNextCard() {
        guard
            let currentCardPostId,
            let currentIndex = ingPosts.firstIndex(where: { $0.postId == currentCardPostId })
        else {
            return
        }

        if currentIndex >= ingPosts.count - 3 {
            loadIngPosts()
        }
    }

    @MainActor
    func loadMyPosts() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }
            do {
                let posts = try await postRepository.getMyPosts()

                await MainActor.run {
                    self.myPosts = posts
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    @MainActor
    func loadLikedPosts() {
        guard !isLoadingLikedPosts else { return }

        isLoadingLikedPosts = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }
            do {
                let posts = try await postRepository.getLikedPosts()
                let enrichedPosts = await self.enrichLikedPosts(with: posts)

                await MainActor.run {
                    self.likedPosts = enrichedPosts
                    self.isLoadingLikedPosts = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoadingLikedPosts = false
                }
            }
        }
    }

    @MainActor
    func loadCommentedPosts() {
        guard !isLoadingCommentedPosts else { return }

        isLoadingCommentedPosts = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else { return }
            do {
                let posts = try await postRepository.getCommentedPosts()

                await MainActor.run {
                    self.commentedPosts = posts
                    self.isLoadingCommentedPosts = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoadingCommentedPosts = false
                }
            }
        }
    }

    private func enrichLikedPosts(with posts: [Post]) async -> [Post] {
        var enriched: [Post] = []

        for post in posts {
            guard
                let postIdString = post.postId,
                let postId = Int64(postIdString),
                let detail = try? await postRepository.getPostDetail(postId: postId)
            else {
                enriched.append(post)
                continue
            }

            enriched.append(convert(postDetail: detail))
        }

        return enriched
    }

    private func convert(postDetail: PostDetail) -> Post {
        Post(
            postId: postDetail.postId,
            writerId: nil,
            title: postDetail.title,
            content: postDetail.content,
            songName: postDetail.songName,
            artistName: postDetail.artistName,
            artworkUrl: postDetail.artworkUrl,
            appleMusicUrl: postDetail.appleMusicUrl,
            createdAt: postDetail.createdAt,
            isCompleted: nil
        )
    }
}
