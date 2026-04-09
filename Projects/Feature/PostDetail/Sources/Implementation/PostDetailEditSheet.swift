import SwiftUI
import Domain
import DesignSystem

struct PostEditSheet: View {
    @ObservedObject var viewModel: PostDetailViewModel
    let detail: PostDetail
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var content: String
    @State private var isSaving: Bool = false
    @State private var errorMessage: String?
    @State private var editMusicTitle: String?
    @State private var editMusicArtist: String?
    @State private var editAlbumName: String
    @State private var editArtworkUrl: String
    @State private var editAppleMusicUrl: String
    @State private var isNavigatingToMusicSearch: Bool = false

    private let maxCharacters: Int = 200

    init(viewModel: PostDetailViewModel, detail: PostDetail) {
        self.viewModel = viewModel
        self.detail = detail
        _title = State(initialValue: detail.title)
        _content = State(initialValue: detail.content)
        _editMusicTitle = State(initialValue: detail.songName.isEmpty ? nil : detail.songName)
        _editMusicArtist = State(initialValue: detail.artistName.isEmpty ? nil : detail.artistName)
        _editAlbumName = State(initialValue: "")
        _editArtworkUrl = State(initialValue: detail.artworkUrl)
        _editAppleMusicUrl = State(initialValue: detail.appleMusicUrl)
    }

    private var hasMusicSelected: Bool {
        editMusicTitle != nil
    }

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color.mainBackground
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }

            VStack(spacing: 0) {
                // Music Section
                HStack {
                    if hasMusicSelected {
                        // Music tag pill with X
                        HStack(spacing: 8) {
                            Image("Musicnote")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)

                            Text("\(editMusicTitle ?? "") \(editMusicArtist ?? "")")
                                .font(.pretendard(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)

                            Button {
                                editMusicTitle = nil
                                editMusicArtist = nil
                                editAlbumName = ""
                                editArtworkUrl = ""
                                editAppleMusicUrl = ""
                                viewModel.clearSelectedMusic()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.textPrimary)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.contentBackground)
                        .clipShape(Capsule())
                    } else {
                        // Waveform circle with + badge
                        NavigationLink {
                            viewModel.makeMusicSearchView()
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                ZStack {
                                    Circle()
                                        .fill(Color.contentBackground)
                                        .frame(width: 64, height: 64)

                                    Image(systemName: "waveform")
                                        .font(.system(size: 20))
                                        .foregroundColor(.primary)
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
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Title & Content
                VStack(alignment: .leading, spacing: 12) {
                    TextField("사연의 제목을 작성해 주세요", text: $title)
                        .font(.pretendard(size: 20, weight: .semiBold))
                        .focused($isFocused)

                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("자유롭게 사연을 작성해주세요")
                                .font(.pretendard(size: 14, weight: .regular))
                                .foregroundColor(.secondary)
                                .padding(.top, 22)
                        }

                        TextEditor(text: $content)
                            .font(.pretendard(size: 14, weight: .regular))
                            .padding(.top, 14)
                            .scrollContentBackground(.hidden)
                            .focused($isFocused)
                            .onChange(of: content) { newValue in
                                if newValue.count > maxCharacters {
                                    content = String(newValue.prefix(maxCharacters))
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer(minLength: 0)

                // Bottom: Character Count + Done Button
                VStack(spacing: 8) {
                    HStack {
                        Text("\(content.count)/\(maxCharacters)")
                            .font(.pretendard(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 24)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.pretendard(size: 12, weight: .regular))
                            .foregroundColor(.red)
                            .padding(.horizontal, 24)
                    }

                    Button {
                        Task { await saveChanges() }
                    } label: {
                        Group {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("done")
                                    .font(.pretendard(size: 16, weight: .semiBold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.textPrimary)
                        .cornerRadius(28)
                    }
                    .disabled(isSaving || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
            }
        }
        .onChange(of: viewModel.selectedMusic) { music in
            if let music {
                editMusicTitle = music.songName
                editMusicArtist = music.artistName
                editAlbumName = music.albumName
                editArtworkUrl = music.artworkUrl
                editAppleMusicUrl = music.previewMusicUrl
            }
        }
    }

    private func saveChanges() async {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "제목을 입력해주세요."
            return
        }

        isSaving = true
        errorMessage = nil
        let success = await viewModel.updatePost(
            title: title,
            content: content,
            albumName: editAlbumName,
            songName: editMusicTitle ?? "",
            artistName: editMusicArtist ?? "",
            artworkUrl: editArtworkUrl,
            appleMusicUrl: editAppleMusicUrl
        )
        isSaving = false

        if success {
            dismiss()
        } else {
            errorMessage = "게시글을 수정하지 못했습니다. 다시 시도해주세요."
        }
    }
}
