import SwiftUI
import DesignSystem

public struct ShareCompleteView: View {
    @Environment(\.dismiss) private var dismiss

    let onHome: () -> Void

    public init(onHome: @escaping () -> Void) {
        self.onHome = onHome
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text("나의 이야기 공유 완료!")
                .font(.pretendard(size: 18, weight: .semiBold))
                .foregroundColor(.textPrimary)

            Text("이제 기다릴 시간이에요.\n친구들이 당신의 이야기에 어울리는 음악을 얹고 있어요.\n다 완성되면, 세상에 단 하나뿐인 플레이리스트가 도착합니다.")
                .font(.pretendard(size: 14, weight: .regular))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainBackground)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onHome()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShareCompleteView(onHome: {})
    }
}
