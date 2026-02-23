import SwiftUI
import DesignSystem

public struct ShareCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    
    let onHome: () -> Void
    
    public init(onHome: @escaping () -> Void) {
        self.onHome = onHome
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 상단 이미지
            Image("shareComplete")
                .clipped()
                .padding(.top, 80)

            Spacer()

            // 텍스트
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
            .padding(.bottom, 200)


            Button {
                onHome()
            } label: {
                Text("홈으로")
                    .font(.helvetica(size: 18, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.horizontal, 48)
                    .frame(height: 56)
                    .background(
                        Capsule()
                            .fill(Color.textPrimary)
                    )
            }
            .padding(.bottom, 40)
        }
        .background(Color.mainBackground)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    NavigationStack {
        ShareCompleteView(onHome: {})
    }
}
