import SwiftUI
import FeatureFactory
import HomeInterface
import FeedInterface
import ShareInterface
import SettingInterface
import AuthInterface
import PostDetailInterface
import Search
import Domain
import Data
import Moya
import Coordinator

@main
struct EeumIOSApp: App {
    init() {
        // 앱 실행 시 deviceId를 가져와서 게스트 로그인
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

        // Moya logger plugin
        let loggerPlugin = NetworkLoggerPlugin(configuration: .init(
            logOptions: .verbose
        ))

        // DI: Repository -> UseCase
        let loginProvider = MoyaProvider<LoginAPI>(plugins: [loggerPlugin])
        let userRepository: UserRepository = UserRepositoryImpl(provider: loginProvider)
        let loginUseCase = DefaultLoginUseCase(userRepository: userRepository)

        // UseCase 실행
        loginUseCase.executeGuestLogin(deviceId: deviceId)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
        }
    }
}

struct RootView: View {
    private let loginUseCase: LoginUseCase
    private let postRepository: PostRepository
    private let commentUseCase: CommentUseCase
    private let likeUseCase: LikeUseCase
    private let shareBuilder: any ShareBuildable
    private let feedBuilder: any FeedBuildable
    private let postDetailCoordinator: PostDetailCoordinating

    init() {
        // Moya logger plugin
        let loggerPlugin = NetworkLoggerPlugin(configuration: .init(
            logOptions: .verbose
        ))

        // Access token plugin
        let authPlugin = AccessTokenPlugin { _ in
            return UserDefaults.standard.string(forKey: "accessToken") ?? ""
        }

        // DI: Repository -> UseCase
        let loginProvider = MoyaProvider<LoginAPI>(plugins: [loggerPlugin])
        let userRepository: UserRepository = UserRepositoryImpl(provider: loginProvider)
        self.loginUseCase = DefaultLoginUseCase(userRepository: userRepository)

        // Post Repository (shared)
        let postProvider = MoyaProvider<PostAPI>(plugins: [loggerPlugin, authPlugin])
        self.postRepository = PostRepositoryImpl(provider: postProvider)

        // Comment Repository and UseCase
        let commentProvider = MoyaProvider<CommentAPI>(plugins: [loggerPlugin, authPlugin])
        let commentRepository = CommentRepositoryImpl(provider: commentProvider)
        self.commentUseCase = DefaultCommentUseCase(repository: commentRepository)

        // Like Repository and UseCase
        let likeProvider = MoyaProvider<LikeAPI>(plugins: [loggerPlugin, authPlugin])
        let likeRepository = LikeRepositoryImpl(provider: likeProvider)
        self.likeUseCase = DefaultLikeUseCase(repository: likeRepository)

        // Share dependencies
        let musicProvider = MoyaProvider<MusicAPI>(plugins: [loggerPlugin])
        let musicRepository = MusicRepositoryImpl(provider: musicProvider)
        let musicSearchUseCase = DefaultMusicSearchUseCase(musicRepository: musicRepository)

        let shareUseCase = DefaultShareUseCase(repository: postRepository)
        let searchBuilder = FeatureFactory.searchBuilder(musicSearchUseCase: musicSearchUseCase)
        let shareCoordinator = ShareCoordinator(searchBuilder: searchBuilder)
        let postDetailCoordinator = PostDetailCoordinator(searchBuilder: searchBuilder)
        self.postDetailCoordinator = postDetailCoordinator
        self.shareBuilder = FeatureFactory.shareBuilder(
            shareUseCase: shareUseCase,
            coordinator: shareCoordinator
        )

        // Feed dependencies
        self.feedBuilder = FeatureFactory.feedBuilder(
            postRepository: postRepository,
            commentUseCase: commentUseCase,
            likeUseCase: likeUseCase,
            postDetailCoordinator: postDetailCoordinator
        )
    }

    var body: some View {
        MainView(
            loginUseCase: loginUseCase,
            postRepository: postRepository,
            commentUseCase: commentUseCase,
            likeUseCase: likeUseCase,
            shareBuilder: shareBuilder,
            feedBuilder: feedBuilder,
            postDetailCoordinator: postDetailCoordinator
        )
    }
}

struct MainView: View {
    let loginUseCase: LoginUseCase
    private let postRepository: PostRepository
    private let commentUseCase: CommentUseCase
    private let likeUseCase: LikeUseCase
    private let shareBuilder: any ShareBuildable
    private let feedBuilder: any FeedBuildable
    private let postDetailCoordinator: PostDetailCoordinating

    init(
        loginUseCase: LoginUseCase,
        postRepository: PostRepository,
        commentUseCase: CommentUseCase,
        likeUseCase: LikeUseCase,
        shareBuilder: any ShareBuildable,
        feedBuilder: any FeedBuildable,
        postDetailCoordinator: PostDetailCoordinating
    ) {
        self.loginUseCase = loginUseCase
        self.postRepository = postRepository
        self.commentUseCase = commentUseCase
        self.likeUseCase = likeUseCase
        self.shareBuilder = shareBuilder
        self.feedBuilder = feedBuilder
        self.postDetailCoordinator = postDetailCoordinator
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.mainBackground
                .ignoresSafeArea()

            // Home Content
            FeatureFactory.homeBuilder(
                loginUseCase: loginUseCase,
                postRepository: postRepository,
                commentUseCase: commentUseCase,
                likeUseCase: likeUseCase,
                postDetailCoordinator: postDetailCoordinator
            ).makeHomeView()

            // Navigation Buttons
            VStack(spacing: 0) {
                Color.mainBackground
                    .frame(height: 1)

                HStack(spacing: 90) {
                    NavigationLink {
                        feedBuilder.makeFeedView(shareBuilder: shareBuilder)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        VStack(spacing: 4) {
                            Image("folder")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                            Text("feed")
                                .font(.caption)
                        }
                        .foregroundColor(.primary)
                        .frame(width: 60)
                    }

                    NavigationLink {
                        shareBuilder.makeShareView()
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        VStack(spacing: 4) {
                            Image("headphone")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                            Text("share")
                                .font(.caption)
                        }
                        .foregroundColor(.primary)
                        .frame(width: 60)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.mainBackground)
            }
            .background(
                Color.mainBackground
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    FeatureFactory.settingBuilder().makeSettingView()
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Image("gear")
                        .renderingMode(.template)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}
