import SwiftUI
import FeedInterface
import Domain
import PostDetailInterface
import ShareInterface

public struct FeedBuilder: FeedBuildable {
    private let postRepository: PostRepository
    private let postDetailBuilder: PostDetailBuildable

    public init(postRepository: PostRepository, postDetailBuilder: PostDetailBuildable) {
        self.postRepository = postRepository
        self.postDetailBuilder = postDetailBuilder
    }

    public func makeFeedView(shareBuilder: any ShareBuildable) -> AnyView {
        let viewModel = FeedViewModel(postRepository: postRepository)
        return AnyView(FeedView(viewModel: viewModel, postDetailBuilder: postDetailBuilder, shareBuilder: shareBuilder))
    }
}
