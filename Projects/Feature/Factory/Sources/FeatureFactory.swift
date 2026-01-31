import Home
import HomeInterface
import Feed
import FeedInterface
import Share
import ShareInterface
import Search
import Setting
import SettingInterface
import Auth
import AuthInterface
import PostDetail
import PostDetailInterface
import Domain

public enum FeatureFactory {
    public static func homeBuilder(
        loginUseCase: LoginUseCase,
        postRepository: PostRepository,
        commentUseCase: CommentUseCase,
        likeUseCase: LikeUseCase,
        postDetailCoordinator: PostDetailCoordinating
    ) -> any HomeBuildable {
        let postDetailBuilder = PostDetailBuilder(
            postRepository: postRepository,
            commentUseCase: commentUseCase,
            likeUseCase: likeUseCase,
            coordinator: postDetailCoordinator
        )
        return HomeBuilder(
            loginUseCase: loginUseCase,
            postRepository: postRepository,
            postDetailBuilder: postDetailBuilder
        )
    }

    public static func feedBuilder(
        postRepository: PostRepository,
        commentUseCase: CommentUseCase,
        likeUseCase: LikeUseCase,
        postDetailCoordinator: PostDetailCoordinating
    ) -> any FeedBuildable {
        let postDetailBuilder = PostDetailBuilder(
            postRepository: postRepository,
            commentUseCase: commentUseCase,
            likeUseCase: likeUseCase,
            coordinator: postDetailCoordinator
        )
        return FeedBuilder(postRepository: postRepository, postDetailBuilder: postDetailBuilder)
    }

    public static func shareBuilder(
        shareUseCase: ShareUseCase,
        coordinator: ShareCoordinating
    ) -> any ShareBuildable {
        ShareBuilder(
            shareUseCase: shareUseCase,
            coordinator: coordinator
        )
    }

    public static func searchBuilder(musicSearchUseCase: MusicSearchUseCase) -> any SearchBuildable {
        SearchBuilder(musicSearchUseCase: musicSearchUseCase)
    }

    public static func settingBuilder() -> any SettingBuildable {
        SettingBuilder()
    }

    public static func authBuilder() -> any AuthBuildable {
        AuthBuilder()
    }
}
