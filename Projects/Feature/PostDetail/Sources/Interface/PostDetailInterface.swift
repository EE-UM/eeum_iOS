import SwiftUI
import Domain

public protocol PostDetailBuildable {
    func makePostDetailView(postId: String) -> AnyView
}

public protocol PostDetailCoordinating {
    func makeMusicSearchView(onSelect: @escaping (Music) -> Void) -> AnyView
}
