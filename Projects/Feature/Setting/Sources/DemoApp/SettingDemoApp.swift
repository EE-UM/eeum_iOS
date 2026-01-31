import SwiftUI
import Setting

@main
struct SettingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            SettingDemoRootView()
        }
    }
}

struct SettingDemoRootView: View {
    private let builder = SettingBuilder()

    var body: some View {
        NavigationStack {
            builder.makeSettingView()
                .padding()
                .navigationTitle("Setting Demo")
        }
    }
}
