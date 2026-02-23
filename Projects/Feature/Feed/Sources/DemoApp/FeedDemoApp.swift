import SwiftUI
import Feed
import Domain
import ShareInterface
import PostDetailInterface

@main
struct FeedDemoApp: App {
    var body: some Scene {
        WindowGroup {
            FeedDemoRootView()
        }
    }
}

struct MockShareBuilder: ShareBuildable {
    func makeShareView() -> AnyView {
        AnyView(Text("Mock Share View"))
    }
}

struct MockPostDetailBuilder: PostDetailBuildable {
    func makePostDetailView(postId: String, source: NavigationSource) -> AnyView {
        AnyView(Text("Mock Post Detail View for post \(postId)"))
    }
}

struct FeedDemoRootView: View {
    private let builder = FeedBuilder(
        postRepository: MockPostRepository(),
        postDetailBuilder: MockPostDetailBuilder()
    )
    private let shareBuilder = MockShareBuilder()

    var body: some View {
        NavigationStack {
            builder.makeFeedView(shareBuilder: shareBuilder)
                .padding()
                .navigationTitle("Feed Demo")
        }
    }
}

// Mock repository for demo purposes
class MockPostRepository: PostRepository {
    func createPost(title: String, content: String, albumName: String, songName: String, artistName: String, artworkUrl: String, appleMusicUrl: String, completionType: String, commentCountLimit: Int) async throws {
        // Mock implementation
    }

    func updatePost(postId: Int64, title: String, content: String) async throws {
        // Mock implementation
    }

    func updatePostState(postId: Int64) async throws {
        // Mock implementation
    }

    func getPostDetail(postId: Int64) async throws -> PostDetail {
        throw NSError(domain: "Mock", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not implemented in mock"])
    }

    func getRandomPosts() async throws -> [Post] {
        return []
    }

    func getMyPosts() async throws -> [Post] {
        return []
    }

    func getLikedPosts() async throws -> [Post] {
        return []
    }

    func getIngPosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] {
        // Return mock Ing posts
        return [
            Post(
                postId: "1",
                writerId: "user1",
                title: "어어남게",
                content: "어어서부터 우리 집은 가난했었고 날을 다치는 외식 몇 번 한 적이 없었던 나가 남자 친이 없었던 연내가 호시 못한다! 잊이 있으면 안되나 못쓸거 없지",
                songName: "Griffin",
                artistName: "Evergreen",
                artworkUrl: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/34/56/12345678-1234-1234-1234-123456789abc/cover.jpg/300x300bb.jpg",
                appleMusicUrl: nil,
                createdAt: nil,
                isCompleted: false
            ),
            Post(
                postId: "2",
                writerId: "user2",
                title: "사연 제목",
                content: "또 다른 사연 내용입니다...",
                songName: "Au/Ra",
                artistName: "Evergreen",
                artworkUrl: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/ab/cd/ef/abcdefgh-5678-5678-5678-567890abcdef/cover.jpg/300x300bb.jpg",
                appleMusicUrl: nil,
                createdAt: nil,
                isCompleted: false
            )
        ]
    }

    func getDonePosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] {
        // Return mock Done posts
        return (1...20).map { index in
            Post(
                postId: "\(index)",
                writerId: "user\(index)",
                title: "사연 제목",
                content: "완료된 사연 내용",
                songName: index % 2 == 0 ? "호랑 (Feat.C JAMM)" : "Griffin",
                artistName: index % 2 == 0 ? "Bewhy" : "Evergreen Au/Ra",
                artworkUrl: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/\(index)/cover.jpg/300x300bb.jpg",
                appleMusicUrl: nil,
                createdAt: nil,
                isCompleted: true
            )
        }
    }

    func getCommentedPosts() async throws -> [Post] {
        return []
    }

    func deletePost(postId: Int64) async throws {
        // Mock implementation
    }
}
