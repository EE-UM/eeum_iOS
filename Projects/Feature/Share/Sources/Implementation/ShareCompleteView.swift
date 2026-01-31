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
            // Content - 여기에 UI 구현
            Spacer()
            
            VStack(spacing: 24) {
                Image("shareComplete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("나의 이야기 공유 완료!")
                    .font(.helvetica(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("이제 기다릴 시간이에요.\n친구들이 당신의 이야기에 어울리는 음악을 얹고 있어요.\n다 완성되면,\n세상에 단 하나뿐인 플레이리스트가 도착합니다.")
                    .font(.helvetica(size: 16, weight: .regular))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Home Button
            Button {
                onHome()
            } label: {
                Text("Home")
                    .font(.helvetica(size: 18, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.textPrimary)
                    .cornerRadius(28)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .background(Color.mainBackground)
    }
}

#Preview {
    NavigationStack {
        ShareCompleteView(onHome: {})
    }
}
