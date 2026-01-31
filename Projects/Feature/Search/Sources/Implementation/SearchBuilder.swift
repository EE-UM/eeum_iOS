import SwiftUI
import DesignSystem
import Domain

public struct SearchBuilder: SearchBuildable {
    private let musicSearchUseCase: MusicSearchUseCase

    public init(musicSearchUseCase: MusicSearchUseCase) {
        self.musicSearchUseCase = musicSearchUseCase
    }

    public func makeSearchView() -> AnyView {
        AnyView(SearchView(musicSearchUseCase: musicSearchUseCase, onSelect: nil))
    }

    public func makeSearchView(onSelect: @escaping (Music) -> Void) -> AnyView {
        AnyView(SearchView(musicSearchUseCase: musicSearchUseCase, onSelect: onSelect))
    }
}


public struct SearchView: View {
    @State private var searchText: String = ""
    @State private var musics: [Music] = []
    @State private var isSearching: Bool = false
    @Environment(\.dismiss) private var dismiss

    private let musicSearchUseCase: MusicSearchUseCase
    private let onSelect: ((Music) -> Void)?

    public init(
        musicSearchUseCase: MusicSearchUseCase,
        onSelect: ((Music) -> Void)? = nil
    ) {
        self.musicSearchUseCase = musicSearchUseCase
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                }

                TextField("", text: $searchText)
                    .font(.body)
                    .onSubmit {
                        performSearch()
                    }
            }
            .padding()
            .background(Color(.systemBackground))

            // Music List
            if isSearching {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(musics) { music in
                            MusicRow(music: music) {
                                onSelect?(music)
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
        .background(Color.mainBackground)
        .navigationBarHidden(true)
    }

    private func performSearch() {
        guard !searchText.isEmpty else { return }

        isSearching = true
        Task {
            do {
                let results = try await musicSearchUseCase.searchMusic(query: searchText)
                await MainActor.run {
                    musics = results
                    isSearching = false
                }
            } catch {
                print("❌ 검색 실패: \(error)")
                await MainActor.run {
                    isSearching = false
                }
            }
        }
    }
}

struct MusicRow: View {
    let music: Music
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Album Art
                AsyncImage(url: URL(string: music.artworkUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color(.systemGray5))
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)

                // Music Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(music.songName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)

                    Text(music.artistName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    SearchView(musicSearchUseCase: PreviewMockMusicSearchUseCase())
}

private final class PreviewMockMusicSearchUseCase: MusicSearchUseCase {
    func searchMusic(query: String) async throws -> [Music] {
        return [
            Music(albumName: "Album", songName: "노래제목", artistName: "가수이름", artworkUrl: "", previewMusicUrl: "")
        ]
    }
}
