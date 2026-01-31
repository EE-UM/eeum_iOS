import SwiftUI
import PostDetailInterface
import Search
import Domain

public struct PostDetailCoordinator: PostDetailCoordinating {
    private let searchBuilder: any SearchBuildable

    public init(searchBuilder: any SearchBuildable) {
        self.searchBuilder = searchBuilder
    }

    public func makeMusicSearchView(onSelect: @escaping (Music) -> Void) -> AnyView {
        searchBuilder.makeSearchView(onSelect: onSelect)
    }
}
