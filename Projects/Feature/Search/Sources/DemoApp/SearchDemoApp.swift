import SwiftUI
import Search
import Domain

@main
struct SearchDemoApp: App {
    var body: some Scene {
        WindowGroup {
            SearchDemoRootView()
        }
    }
}

struct SearchDemoRootView: View {
    private let builder = SearchBuilder(musicSearchUseCase: MockMusicSearchUseCase())

    var body: some View {
        NavigationStack {
            builder.makeSearchView()
                .padding()
                .navigationTitle("Search Demo")
        }
    }
}

// Mock UseCase for Demo
final class MockMusicSearchUseCase: MusicSearchUseCase {
    func searchMusic(query: String) async throws -> [Music] {
        return [
            Music(albumName: "Album 1", songName: "노래제목 1", artistName: "가수이름 1", artworkUrl: "", previewMusicUrl: ""),
            Music(albumName: "Album 2", songName: "노래제목 2", artistName: "가수이름 2", artworkUrl: "", previewMusicUrl: ""),
        ]
    }
}
