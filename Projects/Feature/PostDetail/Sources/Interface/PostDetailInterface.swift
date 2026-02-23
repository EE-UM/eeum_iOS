import SwiftUI
import Domain

public enum NavigationSource {
    case home
    case feed
}

public protocol PostDetailBuildable {
    func makePostDetailView(postId: String, source: NavigationSource) -> AnyView
}

public protocol PostDetailCoordinating {
    func makeMusicSearchView(onSelect: @escaping (Music) -> Void) -> AnyView
}
