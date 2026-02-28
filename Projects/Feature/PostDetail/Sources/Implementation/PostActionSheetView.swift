import SwiftUI
import DesignSystem

struct PostActionSheetView: View {
    let isProcessing: Bool
    let onEdit: () -> Void
    let onComplete: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.textFootnote.opacity(0.4))
                .frame(width: 48, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 24)

            VStack(spacing: 0) {
                actionRow(
                    icon: "pencil",
                    title: "수정",
                    action: onEdit
                )

                Divider()

                actionRow(
                    icon: "checkmark.seal",
                    title: "완료 처리",
                    action: onComplete
                )

                Divider()

                actionRow(
                    icon: "trash",
                    title: "삭제",
                    isDestructive: true,
                    action: onDelete
                )
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.mainBackground)
        .disabled(isProcessing)
        .overlay {
            if isProcessing {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
    }

    @ViewBuilder
    private func actionRow(
        icon: String,
        title: String,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isDestructive ? .red : .textPrimary)

                Text(title)
                    .font(.pretendard(size: 16, weight: .medium))
                    .foregroundColor(isDestructive ? .red : .textPrimary)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}
