import SwiftUI
import Domain
import FeatureFactory
import HomeInterface
import FeedInterface
import ShareInterface
import SettingInterface
import AuthInterface
import Data
import Moya
import Coordinator

struct ContentView: View {
    private let homeBuilder: any HomeBuildable
    private let feedBuilder: any FeedBuildable
    private let shareBuilder: any ShareBuildable
    private let settingBuilder: any SettingBuildable
    private let authBuilder: any AuthBuildable

    init(loginUseCase: LoginUseCase) {
        // Access token plugin
        let authPlugin = AccessTokenPlugin { _ in
            return UserDefaults.standard.string(forKey: "accessToken") ?? ""
        }

        let musicProvider = MoyaProvider<MusicAPI>()
        let musicRepository = MusicRepositoryImpl(provider: musicProvider)
        let musicSearchUseCase = DefaultMusicSearchUseCase(musicRepository: musicRepository)

        let postProvider = MoyaProvider<PostAPI>(plugins: [authPlugin])
        let postRepository = PostRepositoryImpl(provider: postProvider)
        let shareUseCase = DefaultShareUseCase(repository: postRepository)

        let commentProvider = MoyaProvider<CommentAPI>(plugins: [authPlugin])
        let commentRepository = CommentRepositoryImpl(provider: commentProvider)
        let commentUseCase = DefaultCommentUseCase(repository: commentRepository)

        let likeProvider = MoyaProvider<LikeAPI>(plugins: [authPlugin])
        let likeRepository = LikeRepositoryImpl(provider: likeProvider)
        let likeUseCase = DefaultLikeUseCase(repository: likeRepository)

        let searchBuilder = FeatureFactory.searchBuilder(musicSearchUseCase: musicSearchUseCase)
        let postDetailCoordinator = PostDetailCoordinator(searchBuilder: searchBuilder)
        let shareCoordinator = ShareCoordinator(searchBuilder: searchBuilder)

        // Home builder with postRepository and commentUseCase
        self.homeBuilder = FeatureFactory.homeBuilder(
            loginUseCase: loginUseCase,
            postRepository: postRepository,
            commentUseCase: commentUseCase,
            likeUseCase: likeUseCase,
            postDetailCoordinator: postDetailCoordinator
        )

        // Feed builder with postRepository and commentUseCase
        self.feedBuilder = FeatureFactory.feedBuilder(
            postRepository: postRepository,
            commentUseCase: commentUseCase,
            likeUseCase: likeUseCase,
            postDetailCoordinator: postDetailCoordinator
        )

        self.shareBuilder = FeatureFactory.shareBuilder(
            shareUseCase: shareUseCase,
            coordinator: shareCoordinator
        )

        self.settingBuilder = FeatureFactory.settingBuilder()
        self.authBuilder = FeatureFactory.authBuilder()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    FeatureSection(title: "Home") {
                        homeBuilder.makeHomeView()
                    }
                    FeatureSection(title: "Feed") {
                        feedBuilder.makeFeedView(shareBuilder: shareBuilder)
                    }
                    FeatureSection(title: "Share") {
                        shareBuilder.makeShareView()
                    }
                    FeatureSection(title: "Setting") {
                        settingBuilder.makeSettingView()
                    }
                    FeatureSection(title: "Auth") {
                        authBuilder.makeAuthView()
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Modular Workspace")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Eeum App")
                .font(.largeTitle)
                .bold()
            Text("Welcome to Eeum")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}

private struct FeatureSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .bold()
                .padding(.horizontal)
            content()
                .padding(.horizontal)
        }
    }
}
