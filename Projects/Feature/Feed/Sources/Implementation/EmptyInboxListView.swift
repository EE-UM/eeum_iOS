import SwiftUI
import DesignSystem

struct EmptyInboxListView: View {
    let message: String

    var body: some View {
        Image("nodata")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }
}
