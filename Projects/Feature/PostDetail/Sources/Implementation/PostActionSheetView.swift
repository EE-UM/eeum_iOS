import SwiftUI
import DesignSystem

struct PostActionSheetView: View {
    let isProcessing: Bool
    let onEdit: () -> Void
    let onComplete: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Capsule()
                .fill(Color.textFootnote.opacity(0.4))
                .frame(width: 48, height: 4)
                .padding(.top, 12)

            VStack(alignment: .leading, spacing: 16) {
                Text("게시글 관리")
                    .font(.pretendard(size: 20, weight: .semiBold))
                    .foregroundColor(.textPrimary)

                actionButton(
                    title: "수정",
                    description: "사연 내용을 다시 손볼 수 있어요.",
                    action: onEdit
                )

                actionButton(
                    title: "완료 처리",
                    description: "플레이리스트 완료 상태로 변경합니다.",
                    action: onComplete
                )

                actionButton(
                    title: "삭제",
                    description: "사연을 완전히 삭제합니다.",
                    role: .destructive,
                    action: onDelete
                )
            }
            .padding(.horizontal, 24)

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
    private func actionButton(
        title: String,
        description: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(role: role) {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.pretendard(size: 18, weight: .semiBold))
                    .foregroundColor(role == .destructive ? .red : .textPrimary)
                Text(description)
                    .font(.pretendard(size: 13, weight: .regular))
                    .foregroundColor(.textFootnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.contentBackground)
            )
        }
        .buttonStyle(.plain)
    }
}
