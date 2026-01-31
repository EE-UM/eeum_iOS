import Foundation
import Combine
import SwiftUI
import Domain
import DesignSystem
import ShareInterface

public final class ShareViewModel: ObservableObject {
    @Published var titleText: String = ""
    @Published var descriptionText: String = ""
    @Published var storyText: String = ""
    @Published var selectedMusicTitle: String?
    @Published var selectedMusicArtist: String?
    @Published var selectedMusicAlbumName: String?
    @Published var selectedMusicArtworkUrl: String?
    @Published var selectedMusicPreviewUrl: String?
    @Published var isSharing: Bool = false
    @Published var shareErrorMessage: String?
    @Published var didShareSuccessfully: Bool = false
    @Published var showSettingsPopup: Bool = false
    @Published var showCompleteView: Bool = false

    let maxCharacters: Int = 200

    private var completionType: CompletionType = .manual
    private var commentLimit: Int = 20

    private let shareUseCase: ShareUseCase
    private let coordinator: ShareCoordinating

    public init(
        shareUseCase: ShareUseCase,
        coordinator: ShareCoordinating
    ) {
        self.shareUseCase = shareUseCase
        self.coordinator = coordinator
    }

    func showSettings() {
        showSettingsPopup = true
    }
    
    func closeCompleteView() {
        showCompleteView = false
        didShareSuccessfully = false
    }

    @MainActor func confirmSettings(type: CompletionType, limit: Int) {
        self.completionType = type
        self.commentLimit = limit
        shareStory()
    }

    func makeMusicSearchView() -> AnyView {
        coordinator.makeMusicSearchView { [weak self] music in
            self?.handleMusicSelection(music)
        }
    }

    private func handleMusicSelection(_ music: Music) {
        selectedMusicTitle = music.songName
        selectedMusicArtist = music.artistName
        selectedMusicAlbumName = music.albumName
        selectedMusicArtworkUrl = music.artworkUrl
        selectedMusicPreviewUrl = music.previewMusicUrl
    }

    @MainActor
    func shareStory() {
        guard !titleText.isEmpty else {
            shareErrorMessage = "사연 제목을 입력해 주세요."
            return
        }

        guard !storyText.isEmpty else {
            shareErrorMessage = "사연 내용을 입력해 주세요."
            return
        }

        shareErrorMessage = nil
        isSharing = true

        Task { [weak self] in
            guard let self else { return }
            do {
                try await shareUseCase.shareStory(
                    title: titleText,
                    description: descriptionText,
                    story: storyText,
                    musicTitle: selectedMusicTitle,
                    musicArtist: selectedMusicArtist,
                    musicAlbumName: selectedMusicAlbumName,
                    musicArtworkUrl: selectedMusicArtworkUrl,
                    musicPreviewUrl: selectedMusicPreviewUrl,
                    completionType: completionType.apiValue,
                    commentCountLimit: completionType.requiresCommentLimit ? commentLimit : 0
                )

                await MainActor.run {
                    self.isSharing = false
                    self.didShareSuccessfully = true
                    self.showCompleteView = true
                }
            } catch {
                await MainActor.run {
                    self.shareErrorMessage = error.localizedDescription
                    self.isSharing = false
                }
            }
        }
    }
}
