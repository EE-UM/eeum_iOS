import SwiftUI
import DesignSystem

struct EmptyInboxListView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image("nodata")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)

            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}
