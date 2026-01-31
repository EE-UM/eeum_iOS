import SwiftUI
import ShareInterface
import Search
import Domain

public struct ShareCoordinator: ShareCoordinating {
    private let searchBuilder: any SearchBuildable

    public init(searchBuilder: any SearchBuildable) {
        self.searchBuilder = searchBuilder
    }

    public func makeMusicSearchView(onSelect: @escaping (Music) -> Void) -> AnyView {
        searchBuilder.makeSearchView(onSelect: onSelect)
    }
}
