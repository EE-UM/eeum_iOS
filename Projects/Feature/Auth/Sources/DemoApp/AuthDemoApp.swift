import SwiftUI
import Auth

@main
struct AuthDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AuthDemoRootView()
        }
    }
}

struct AuthDemoRootView: View {
    private let builder = AuthBuilder()

    var body: some View {
        NavigationStack {
            builder.makeAuthView()
                .padding()
                .navigationTitle("Auth Demo")
        }
    }
}
