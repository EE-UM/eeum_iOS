import SwiftUI
import Domain
import PostDetailInterface

#Preview("Post Detail View") {
    let repository = PreviewPostRepository()
    let commentUseCase = PreviewCommentUseCase()
    let likeUseCase = PreviewLikeUseCase()
    let coordinator = PreviewPostDetailCoordinator()
    let viewModel = PostDetailViewModel(
        postRepository: repository,
        commentUseCase: commentUseCase,
        likeUseCase: likeUseCase,
        coordinator: coordinator,
        postId: "1"
    )
    viewModel.postDetail = repository.sampleDetail
    return NavigationView {
        PostDetailView(viewModel: viewModel)
    }
}

private final class PreviewPostRepository: PostRepository {
    let sampleDetail: PostDetail = .init(
        postId: "1",
        title: "달콤쌉싸름한 밤 산책",
        content: "찬 공기를 마시며 걷다가 문득 떠올랐던 노래와 추억을 남겨 봅니다.",
        songName: "밤양갱",
        artistName: "비비",
        artworkUrl: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/44/8e/41/448e4153-4047-a2db-50d4-52e5c675985d/cover-KMCA1127-0000695-2021-0015-00.jpg/300x300bb.jpg",
        appleMusicUrl: "",
        createdAt: "2025-01-01T12:00:00Z",
        isLiked: true,
        comments: [
            Comment(
                commentId: "101",
                content: "이 노래 들으면 겨울밤이 생각나요.",
                songName: "첫눈",
                artistName: "정승환",
                artworkUrl: nil
            ),
            Comment(
                commentId: "102",
                content: "산책하며 들을만한 추천 곡이에요!",
                songName: "너에게 가는 길",
                artistName: "성시경",
                artworkUrl: nil
            )
        ]
    )

    func createPost(title: String, content: String, albumName: String, songName: String, artistName: String, artworkUrl: String, appleMusicUrl: String, completionType: String, commentCountLimit: Int) async throws {}

    func updatePost(postId: Int64, title: String, content: String) async throws {}

    func updatePostState(postId: Int64) async throws {}

    func getPostDetail(postId: Int64) async throws -> PostDetail {
        sampleDetail
    }

    func getRandomPosts() async throws -> [Post] { [] }

    func getMyPosts() async throws -> [Post] { [] }

    func getLikedPosts() async throws -> [Post] { [] }

    func getIngPosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] { [] }

    func getDonePosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] { [] }

    func getCommentedPosts() async throws -> [Post] { [] }

    func deletePost(postId: Int64) async throws {}
}

private struct PreviewCommentUseCase: CommentUseCase {
    func createComment(postId: Int64, content: String, albumName: String, songName: String, artistName: String, artworkUrl: String, appleMusicUrl: String) async throws {}

    func getComments(postId: Int64) async throws -> [Comment] { [] }

    func updateComment(commentId: Int64, content: String) async throws {}

    func deleteComment(commentId: Int64) async throws {}
}

private struct PreviewLikeUseCase: LikeUseCase {
    func fetchIsLiked(postId: Int64) async throws -> Bool { true }
    func like(postId: Int64) async throws {}
    func unlike(postId: Int64) async throws {}
    func fetchLikeCount(postId: Int64) async throws -> Int { 0 }
}

private struct PreviewPostDetailCoordinator: PostDetailCoordinating {
    func makeMusicSearchView(onSelect: @escaping (Music) -> Void) -> AnyView {
        AnyView(Text("Preview Search View"))
    }
}
