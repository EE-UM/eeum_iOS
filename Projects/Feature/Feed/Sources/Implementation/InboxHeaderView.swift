import SwiftUI
import DesignSystem

struct InboxHeaderView: View {
    let title: String
    let count: Int
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.textPrimary)

            Text("\(count)개")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)

            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.textFootnote)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}
