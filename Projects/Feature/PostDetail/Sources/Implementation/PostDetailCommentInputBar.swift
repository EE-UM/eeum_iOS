import SwiftUI
import DesignSystem

struct CommentInputBar: View {
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
                HStack(spacing: 8) {
                    if let selectedMusicArtworkURL,
                       let url = URL(string: selectedMusicArtworkURL)
                    {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
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

                    Text(selectedMusicTitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Spacer()

                    if let onRemoveMusic {
                        Button(action: onRemoveMusic) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(16)
                .padding(.horizontal, 16)
            }

            HStack(spacing: 12) {
                Button(action: onTapAddMusic) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }

                TextField("사연과 관련된 노래의 음원 추가해보세요.", text: $commentText)
                    .font(.system(size: 14))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .focused($isCommentFocused)

                Button(action: onSend) {
                    Image("send")
                        .font(.system(size: 24))
                        .foregroundColor(commentText.isEmpty ? .gray : .black)
                }
                .disabled(commentText.isEmpty)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(Color.mainBackground)
    }
}
