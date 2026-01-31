import SwiftUI
import AuthInterface
import Domain

public struct AuthBuilder: AuthBuildable {

    public init() {}

    public func makeAuthView() -> AnyView {
        AnyView(AuthView())
    }
}

private struct AuthView: View {

    var body: some View {
        VStack {
            Text("Shake")
            Text("to receive someone's letter\nanswer with music")
        }
    }
}

#Preview {
    AuthView()
}
