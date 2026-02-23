import Foundation
import SwiftUI
import Domain
import PostDetailInterface

@MainActor
final class PostDetailViewModel: ObservableObject {
    @Published var postDetail: PostDetail?
    @Published var isLoading: Bool = false
    @Published var selectedMusic: Music?
    @Published var isUpdatingLike: Bool = false
    @Published var isMyPost: Bool = false
    @Published var isManagingPost: Bool = false
    @Published var didDeletePost: Bool = false
    @Published var currentPlayingURL: String?

    private let postRepository: PostRepository
    private let commentUseCase: CommentUseCase
    private let likeUseCase: LikeUseCase
    private let coordinator: PostDetailCoordinating
    private let postId: String
    private var myPostIds: Set<String> = []
    private var hasLoadedMyPosts: Bool = false
    private let audioPlayer = AudioPlayerService.shared

    init(
        postRepository: PostRepository,
        commentUseCase: CommentUseCase,
        likeUseCase: LikeUseCase,
        coordinator: PostDetailCoordinating,
        postId: String
    ) {
        self.postRepository = postRepository
        self.commentUseCase = commentUseCase
        self.likeUseCase = likeUseCase
        self.coordinator = coordinator
        self.postId = postId
    }

    var selectedMusicDisplayText: String? {
        guard let selectedMusic else { return nil }
        if selectedMusic.artistName.isEmpty {
            return selectedMusic.songName
        }
        return "\(selectedMusic.songName) - \(selectedMusic.artistName)"
    }

    @MainActor
    func loadPostDetail() {
        Task {
            await loadPostDetailAsync()
        }
    }

    @MainActor
    private func loadPostDetailAsync() async {
        guard !isLoading else { return }

        isLoading = true
        do {
            let detail = try await postRepository.getPostDetail(postId: Int64(postId) ?? 0)
            postDetail = detail
            isMyPost = await checkIfMyPost(postId: detail.postId)
            isLoading = false
        } catch {
            isLoading = false
            print("❌ Failed to load post detail: \(error)")
        }
    }

    @MainActor
    func createComment(content: String) async {
        guard let postIdInt = Int64(postId) else { return }

        let detail = postDetail
        let albumName = selectedMusic?.albumName ?? ""
        let songName = selectedMusic?.songName ?? detail?.songName ?? ""
        let artistName = selectedMusic?.artistName ?? detail?.artistName ?? ""
        let artworkUrl = selectedMusic?.artworkUrl ?? detail?.artworkUrl ?? ""
        let appleMusicUrl = selectedMusic?.previewMusicUrl ?? detail?.appleMusicUrl ?? ""

        do {
            try await commentUseCase.createComment(
                postId: postIdInt,
                content: content,
                albumName: albumName,
                songName: songName,
                artistName: artistName,
                artworkUrl: artworkUrl,
                appleMusicUrl: appleMusicUrl
            )
            await loadPostDetailAsync()
            await MainActor.run {
                self.selectedMusic = nil
            }
        } catch {
            print("❌ Failed to create comment: \(error)")
        }
    }

    func toggleLike() {
        guard !isUpdatingLike, let detail = postDetail, let postIdInt = Int64(postId) else { return }
        isUpdatingLike = true

        Task {
            do {
                if detail.isLiked {
                    try await likeUseCase.unlike(postId: postIdInt)
                    await MainActor.run { self.updateLikeState(isLiked: false) }
                } else {
                    try await likeUseCase.like(postId: postIdInt)
                    await MainActor.run { self.updateLikeState(isLiked: true) }
                }
            } catch {
                print("❌ Failed to toggle like: \(error)")
            }

            await MainActor.run {
                self.isUpdatingLike = false
            }
        }
    }

    func clearSelectedMusic() {
        selectedMusic = nil
    }

    func makeMusicSearchView() -> AnyView {
        coordinator.makeMusicSearchView { [weak self] music in
            Task { @MainActor in
                self?.selectedMusic = music
            }
        }
    }

    func togglePlay() {
        guard let detail = postDetail, !detail.appleMusicUrl.isEmpty else { return }
        audioPlayer.toggle(url: detail.appleMusicUrl)
        currentPlayingURL = audioPlayer.isPlaying ? detail.appleMusicUrl : nil
    }

    func playComment(url: String) {
        guard !url.isEmpty else { return }
        audioPlayer.toggle(url: url)
        currentPlayingURL = audioPlayer.isPlaying ? url : nil
    }

    func isPlaying(url: String) -> Bool {
        audioPlayer.isCurrentlyPlaying(url: url)
    }

    var isPostPlaying: Bool {
        guard let detail = postDetail else { return false }
        return audioPlayer.isCurrentlyPlaying(url: detail.appleMusicUrl)
    }

    func markPostCompleted() {
        guard !isManagingPost, let postIdInt = Int64(postId) else { return }
        isManagingPost = true

        Task {
            do {
                try await postRepository.updatePostState(postId: postIdInt)
                await loadPostDetailAsync()
                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .postDidUpdate,
                        object: nil,
                        userInfo: [
                            "postId": self.postId,
                            "action": PostUpdateAction.completed.rawValue
                        ]
                    )
                }
            } catch {
                print("❌ Failed to mark post completed: \(error)")
            }

            await MainActor.run {
                self.isManagingPost = false
            }
        }
    }

    func deletePost() {
        guard !isManagingPost, let postIdInt = Int64(postId) else { return }
        isManagingPost = true

        Task {
            do {
                try await postRepository.deletePost(postId: postIdInt)
                await MainActor.run {
                    if let detail = self.postDetail {
                        self.myPostIds.remove(detail.postId)
                    }
                    self.isMyPost = false
                    self.didDeletePost = true
                    self.isManagingPost = false
                    NotificationCenter.default.post(
                        name: .postDidUpdate,
                        object: nil,
                        userInfo: [
                            "postId": self.postId,
                            "action": PostUpdateAction.deleted.rawValue
                        ]
                    )
                }
            } catch {
                await MainActor.run {
                    self.isManagingPost = false
                }
                print("❌ Failed to delete post: \(error)")
            }
        }
    }

    @MainActor
    func updatePost(title: String, content: String) async -> Bool {
        guard !isManagingPost, let postIdInt = Int64(postId) else { return false }
        isManagingPost = true
        defer { isManagingPost = false }

        do {
            try await postRepository.updatePost(postId: postIdInt, title: title, content: content)
            await loadPostDetailAsync()
            return true
        } catch {
            print("❌ Failed to update post: \(error)")
            return false
        }
    }

    private func updateLikeState(isLiked: Bool) {
        guard let detail = postDetail else { return }
        postDetail = PostDetail(
            postId: detail.postId,
            title: detail.title,
            content: detail.content,
            songName: detail.songName,
            artistName: detail.artistName,
            artworkUrl: detail.artworkUrl,
            appleMusicUrl: detail.appleMusicUrl,
            createdAt: detail.createdAt,
            isLiked: isLiked,
            comments: detail.comments
        )
    }

    @MainActor
    private func checkIfMyPost(postId: String) async -> Bool {
        if myPostIds.contains(postId) {
            return true
        }

        if hasLoadedMyPosts {
            return false
        }

        do {
            let posts = try await postRepository.getMyPosts()
            myPostIds = Set(posts.compactMap { $0.postId })
            hasLoadedMyPosts = true
            return myPostIds.contains(postId)
        } catch {
            print("❌ Failed to load my posts: \(error)")
            return false
        }
    }
}
