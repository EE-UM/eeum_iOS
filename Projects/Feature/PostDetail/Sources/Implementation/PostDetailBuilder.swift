import SwiftUI
import PostDetailInterface
import Domain

public struct PostDetailBuilder: PostDetailBuildable {
    private let postRepository: PostRepository
    private let commentUseCase: CommentUseCase
    private let likeUseCase: LikeUseCase
    private let coordinator: PostDetailCoordinating

    public init(
        postRepository: PostRepository,
        commentUseCase: CommentUseCase,
        likeUseCase: LikeUseCase,
        coordinator: PostDetailCoordinating
    ) {
        self.postRepository = postRepository
        self.commentUseCase = commentUseCase
        self.likeUseCase = likeUseCase
        self.coordinator = coordinator
    }

    @MainActor public func makePostDetailView(postId: String, source: NavigationSource) -> AnyView {
        let viewModel = PostDetailViewModel(
            postRepository: postRepository,
            commentUseCase: commentUseCase,
            likeUseCase: likeUseCase,
            coordinator: coordinator,
            postId: postId
        )
        return AnyView(PostDetailView(viewModel: viewModel, source: source))
    }
}
