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
    let onTapAddMusic: () -> Void
    let onSend: () -> Void
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

                TextField(inputPlaceholder, text: $commentText)
                    .font(.system(size: 13))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .focused($isCommentFocused)

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
