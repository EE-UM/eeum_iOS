import SwiftUI
import HomeInterface
import Domain
import DesignSystem
import PostDetailInterface

public struct HomeBuilder: HomeBuildable {
    private let loginUseCase: LoginUseCase
    private let postRepository: PostRepository
    private let postDetailBuilder: PostDetailBuildable

    public init(loginUseCase: LoginUseCase, postRepository: PostRepository, postDetailBuilder: PostDetailBuildable) {
        self.loginUseCase = loginUseCase
        self.postRepository = postRepository
        self.postDetailBuilder = postDetailBuilder
    }

    public func makeHomeView() -> AnyView {
        let viewModel = HomeViewModel(postRepository: postRepository)
        return AnyView(HomeView(loginUseCase: loginUseCase, viewModel: viewModel, postDetailBuilder: postDetailBuilder))
    }
}

// MARK: - ViewModel
private final class HomeViewModel: ObservableObject {
    @Published var randomPost: Post?
    @Published var showRandomPost: Bool = false
    @Published var isLoading: Bool = false
    @Published var showNoPostAlert: Bool = false

    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    @MainActor
    func loadRandomPost() {
        guard !isLoading else {
            print("⚠️ Already loading")
            return
        }

        print("🎲 Loading random post...")
        isLoading = true
        Task {
            do {
                let posts = try await postRepository.getRandomPosts()
                print("✅ Received \(posts.count) posts")
                if let post = posts.first {
                    randomPost = post
                    showRandomPost = true
                    print("✅ Showing random post: \(post.title ?? "No title")")
                } else {
                    showNoPostAlert = true
                }
                isLoading = false
            } catch {
                isLoading = false
                print("❌ Failed to load random post: \(error)")
            }
        }
    }
}

// MARK: - View
private struct HomeView: View {
    let loginUseCase: LoginUseCase
    @StateObject var viewModel: HomeViewModel
    let postDetailBuilder: PostDetailBuildable

    var body: some View {
        ZStack {
            if viewModel.showRandomPost, let post = viewModel.randomPost {
                RandomPostCard(
                    post: post,
                    postDetailBuilder: postDetailBuilder,
                    onDismiss: {
                        viewModel.showRandomPost = false
                    }
                )
                .id(post.postId)
                .transition(.move(edge: .trailing))
            } else {
                VStack {
                    Spacer()
                        .frame(maxHeight: 100)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .lastTextBaseline, spacing: 8) {
                            Text("Shake")
                                .font(.helvetica(size: 96, weight: .bold))
                                .bold()
                            Image("logo")
                        }
                        Text("to receive someone's letter\nanswer with music")
                            .font(.helvetica(size: 18, weight: .regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.showRandomPost)
        .onShake {
            print("📳 Shake detected!")
            viewModel.loadRandomPost()
        }
        .alert("알림", isPresented: $viewModel.showNoPostAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("현재 받을 수 있는 게시글이 없습니다.")
        }
        #if targetEnvironment(simulator)
        .onTapGesture {
            viewModel.loadRandomPost()
        }
        #endif
    }
}

// MARK: - Random Post Card
private struct RandomPostCard: View {
    let post: Post
    let postDetailBuilder: PostDetailBuildable
    let onDismiss: () -> Void

    @State private var cardAppeared: Bool = false
    @State private var shakeAngle: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            // Description
            Text("Shake to receive someone's letter\nanswer with music")
                .font(.helvetica(size: 18, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 12)

            // Post Card
            VStack(alignment: .leading, spacing: 12) {
                Text(post.title ?? "제목 없음")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Text(post.content ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
                    .lineLimit(8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
            .frame(minHeight: 380, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 234/255, green: 232/255, blue: 224/255).opacity(0.5))
            )
            .padding(.horizontal, 42)
            .padding(.top, 32)
            .rotationEffect(.degrees(shakeAngle))
            .offset(y: cardAppeared ? 0 : 300)
            .opacity(cardAppeared ? 1 : 0)

            Spacer()

            // View Button
            if let postId = post.postId {
                NavigationLink {
                    postDetailBuilder.makePostDetailView(postId: postId, source: .home)
                } label: {
                    Text("view")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.black)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 98)
                .opacity(cardAppeared ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainBackground)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("logo")
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                cardAppeared = true
            }
            // Gentle single shake: left → right → settle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    shakeAngle = -4
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    shakeAngle = 3
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    shakeAngle = 0
                }
            }
        }
    }
}

// MARK: - Shake Gesture
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

struct ShakeModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(ShakeModifier(action: action))
    }
}

#Preview {
    HomeView(
        loginUseCase: PreviewMockLoginUseCase(),
        viewModel: HomeViewModel(postRepository: PreviewPostRepository()),
        postDetailBuilder: PreviewPostDetailBuilder()
    )
}

private struct PreviewPostDetailBuilder: PostDetailBuildable {
    func makePostDetailView(postId: String, source: NavigationSource) -> AnyView {
        AnyView(Text("Post Detail: \(postId)"))
    }
}

private final class PreviewMockLoginUseCase: LoginUseCase {
    func executeGuestLogin(deviceId: String) {
        print("Preview Mock: Guest login")
    }
}

private final class PreviewPostRepository: PostRepository {
    func createPost(title: String, content: String, albumName: String, songName: String, artistName: String, artworkUrl: String, appleMusicUrl: String, completionType: String, commentCountLimit: Int) async throws {}
    func updatePost(postId: Int64, title: String, content: String, albumName: String, songName: String, artistName: String, artworkUrl: String, appleMusicUrl: String) async throws {}
    func updatePostState(postId: Int64) async throws {}
    func getPostDetail(postId: Int64) async throws -> PostDetail {
        PostDetail(postId: "1", title: "Test", content: "Test", songName: "Song", artistName: "Artist", artworkUrl: "", appleMusicUrl: "", createdAt: "", isLiked: false, comments: [])
    }
    func getRandomPosts() async throws -> [Post] {
        [Post(postId: "1", writerId: nil, title: "어머님께", content: "어려서부터 우리 집은 가난했었기 때문에 다른 집처럼 집에 혼자 있던 시간이 많았어요. 어머니께서는 항상 바쁘셔서 같이 놀아주시는 시간도 별로 없었고...", songName: nil, artistName: nil, artworkUrl: nil, appleMusicUrl: nil, createdAt: nil, isCompleted: nil)]
    }
    func getMyPosts() async throws -> [Post] { [] }
    func getLikedPosts() async throws -> [Post] { [] }
    func getIngPosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] { [] }
    func getDonePosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] { [] }
    func getCommentedPosts() async throws -> [Post] { [] }
    func deletePost(postId: Int64) async throws {}
}
