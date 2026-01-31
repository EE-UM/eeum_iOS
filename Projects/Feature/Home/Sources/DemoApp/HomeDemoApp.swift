import SwiftUI
import Home
import Domain

@main
struct HomeDemoApp: App {
    var body: some Scene {
        WindowGroup {
            HomeDemoRootView()
        }
    }
}

struct HomeDemoRootView: View {
    private let builder = HomeBuilder(loginUseCase: MockLoginUseCase())

    var body: some View {
        NavigationStack {
            builder.makeHomeView()
                .padding()
                .navigationTitle("Home Demo")
        }
    }
}

// Mock UseCase for Demo
final class MockLoginUseCase: LoginUseCase {
    func executeGuestLogin(deviceId: String) {
        print("Mock: Guest login with deviceId: \(deviceId)")
    }
}
