import SwiftUI
import DesignSystem

struct EmptyInboxListView: View {
    let message: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.stack.3d.up.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))

            Text(message)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.textFootnote)
        }
        .background(Color.mainBackground)
    }
}
