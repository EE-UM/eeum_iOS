import SwiftUI
import Domain

public protocol SearchBuildable {
    func makeSearchView() -> AnyView
    func makeSearchView(onSelect: @escaping (Music) -> Void) -> AnyView
}
