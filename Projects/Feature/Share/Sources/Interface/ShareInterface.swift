import SwiftUI
import Domain

public protocol ShareBuildable {
    func makeShareView() -> AnyView
}

public protocol ShareCoordinating {
    func makeMusicSearchView(onSelect: @escaping (Music) -> Void) -> AnyView
}
