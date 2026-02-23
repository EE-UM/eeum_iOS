import SwiftUI
import DesignSystem
import Domain
import ShareInterface
import UIKit

public struct ShareBuilder: ShareBuildable {
    private let shareUseCase: ShareUseCase
    private let coordinator: ShareCoordinating

    public init(
        shareUseCase: ShareUseCase,
        coordinator: ShareCoordinating
    ) {
        self.shareUseCase = shareUseCase
        self.coordinator = coordinator
    }

    public func makeShareView() -> AnyView {
        let viewModel = ShareViewModel(
            shareUseCase: shareUseCase,
            coordinator: coordinator
        )
        return AnyView(ShareView(viewModel: viewModel))
    }
}

public struct ShareView: View {
    @StateObject private var viewModel: ShareViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: ShareViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Voice Recording Button / Album Art
                HStack {
                    NavigationLink {
                        viewModel.makeMusicSearchView()
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            ZStack {
                                Circle()
                                    .fill(Color.contentBackground)
                                    .frame(width: 64, height: 64)

                                if
                                    let artworkUrl = viewModel.selectedMusicArtworkUrl,
                                    let url = URL(string: artworkUrl)
                                {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "waveform")
                                        .font(.system(size: 20))
                                        .foregroundColor(.primary)
                                }
                            }

                            Circle()
                                .fill(Color.accentPrimary)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 5, y: -5)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Title Input
                VStack(alignment: .leading, spacing: 12) {
                    TextField("사연의 제목을 작성해 주세요", text: $viewModel.titleText)
                        .font(.title3)
                        .fontWeight(.semibold)

                    ZStack(alignment: .topLeading) {
                        if viewModel.storyText.isEmpty {
                            Text(" 00자에서 00자 이내로 자유롭게 공유하고싶은 사연을 작성해주세요")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 22)
                        }

                        TextEditor(text: $viewModel.storyText)
                            .padding(.top, 14)
                            .scrollContentBackground(.hidden)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top, 20)

                Spacer(minLength: 0)

                // Bottom: Character Count + Share Button
                VStack(spacing: 8) {
                    HStack {
                        Text("\(viewModel.storyText.count)/\(viewModel.maxCharacters)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)

                    if let errorMessage = viewModel.shareErrorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Button {
                        viewModel.showSettings()
                    } label: {
                        Group {
                            if viewModel.isSharing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("share")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.textPrimary)
                        .cornerRadius(28)
                    }
                    .disabled(viewModel.isSharing)
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 16)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("home")
                            .foregroundColor(.primary)
                    }
                }
            }

            // Settings Popup
            if viewModel.showSettingsPopup {
                SharePopupView(
                    isPresented: $viewModel.showSettingsPopup,
                    onConfirm: { type, limit in
                        viewModel.confirmSettings(type: type, limit: limit)
                    }
                )
            }
        }
        .alert("입력 확인", isPresented: $viewModel.showValidationAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.validationMessage)
        }
        .fullScreenCover(isPresented: $viewModel.showCompleteView) {
            ShareCompleteView {
                viewModel.closeCompleteView()
                dismiss()
            }
        }
    }
}

// Helper function to find NavigationController
private func findNavigationController() -> UINavigationController? {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
        return findNavigationControllerInView(window.rootViewController)
    }
    return nil
}

private func findNavigationControllerInView(_ viewController: UIViewController?) -> UINavigationController? {
    if let navigationController = viewController as? UINavigationController {
        return navigationController
    }
    
    if let tabBarController = viewController as? UITabBarController {
        for child in tabBarController.children {
            if let nav = findNavigationControllerInView(child) {
                return nav
            }
        }
    }
    
    for child in viewController?.children ?? [] {
        if let nav = findNavigationControllerInView(child) {
            return nav
        }
    }
    
    return nil
}

#Preview {
    ShareView(
        viewModel: ShareViewModel(
            shareUseCase: PreviewShareUseCase(),
            coordinator: PreviewShareCoordinator()
        )
    )
}

private final class PreviewShareUseCase: ShareUseCase {
    func shareStory(
        title: String,
        description: String,
        story: String,
        musicTitle: String?,
        musicArtist: String?,
        musicAlbumName: String?,
        musicArtworkUrl: String?,
        musicPreviewUrl: String?,
        completionType: String,
        commentCountLimit: Int
    ) async throws {}
}

private struct PreviewShareCoordinator: ShareCoordinating {
    func makeMusicSearchView(onSelect: @escaping (Music) -> Void) -> AnyView {
        AnyView(Text("Preview Search View"))
    }
}
