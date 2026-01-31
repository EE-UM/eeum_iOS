import SwiftUI
import ShareInterface

public protocol FeedBuildable {
    func makeFeedView(shareBuilder: any ShareBuildable) -> AnyView
}
