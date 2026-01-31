import SwiftUI

public protocol AuthBuildable {
    func makeAuthView() -> AnyView
}
