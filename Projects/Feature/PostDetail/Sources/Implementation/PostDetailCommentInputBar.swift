import SwiftUI
import DesignSystem

private let inputPlaceholder = "사연과 관련된 노래와 글을 추가해보세요."

// MARK: - 디테일 하단 가짜 입력바 (탭하면 시트 열림)
struct CommentInputBar: View {
    let selectedMusicTitle: String?
    let selectedMusicArtworkURL: String?
    let onTapAddMusic: () -> Void
    let onTapInput: () -> Void
    let onRemoveMusic: (() -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            if let selectedMusicTitle {
                MusicAttachmentRow(
                    title: selectedMusicTitle,
                    artworkURL: selectedMusicArtworkURL,
                    onRemove: onRemoveMusic
                )
            }

            HStack(spacing: 8) {
                Button(action: onTapAddMusic) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.black)
                }

                Button(action: onTapInput) {
                    Text(inputPlaceholder)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                }

                Image("send")
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 10)
        .background(Color.mainBackground)
    }
}

// MARK: - 시트 안에서 사용하는 실제 입력바
struct SheetCommentInputBar: View {
    @Binding var commentText: String
    @FocusState var isCommentFocused: Bool
    let selectedMusicTitle: String?
    let selectedMusicArtworkURL: String?
    let selectedMusicSongName: String?
    let selectedMusicArtistName: String?
    let onTapAddMusic: () -> Void
    let onSend: () -> Void
    let onRemoveMusic: (() -> Void)?

    init(
        commentText: Binding<String>,
        isCommentFocused: FocusState<Bool>,
        selectedMusicTitle: String?,
        selectedMusicArtworkURL: String?,
        selectedMusicSongName: String? = nil,
        selectedMusicArtistName: String? = nil,
        onTapAddMusic: @escaping () -> Void,
        onSend: @escaping () -> Void,
        onRemoveMusic: (() -> Void)?
    ) {
        self._commentText = commentText
        self._isCommentFocused = isCommentFocused
        self.selectedMusicTitle = selectedMusicTitle
        self.selectedMusicArtworkURL = selectedMusicArtworkURL
        self.selectedMusicSongName = selectedMusicSongName
        self.selectedMusicArtistName = selectedMusicArtistName
        self.onTapAddMusic = onTapAddMusic
        self.onSend = onSend
        self.onRemoveMusic = onRemoveMusic
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Button(action: onTapAddMusic) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.black)
                }

                // 입력 영역 (음악 태그 + 텍스트)
                VStack(alignment: .leading, spacing: 6) {
                    if selectedMusicTitle != nil {
                        HStack(spacing: 6) {
                            if let songName = selectedMusicSongName {
                                Text(songName)
                                    .font(.pretendard(size: 13, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                    .lineLimit(1)
                            }

                            if let artistName = selectedMusicArtistName, !artistName.isEmpty {
                                Text(artistName)
                                    .font(.pretendard(size: 13, weight: .regular))
                                    .foregroundColor(.textFootnote)
                                    .lineLimit(1)
                            }

                            if let onRemoveMusic {
                                Button(action: onRemoveMusic) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.textFootnote)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.contentBackground)
                        .clipShape(Capsule())
                    }

                    TextField(inputPlaceholder, text: $commentText, axis: .vertical)
                        .font(.system(size: 13))
                        .lineLimit(1...5)
                        .focused($isCommentFocused)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)

                Button(action: onSend) {
                    Image("send")
                }
                .disabled(commentText.isEmpty)
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 10)
        .background(Color.mainBackground)
    }
}

// MARK: - 음악 첨부 표시 행
private struct MusicAttachmentRow: View {
    let title: String
    let artworkURL: String?
    let onRemove: (() -> Void)?

    var body: some View {
        HStack(spacing: 8) {
            if let artworkURL, let url = URL(string: artworkURL) {
                AsyncImage(url: url) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ZStack {
                    Color.gray.opacity(0.15)
                    Image(systemName: "music.note")
                        .foregroundColor(.gray)
                }
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.black)
                .lineLimit(1)

            Spacer()

            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
        .padding(.horizontal, 12)
    }
}
