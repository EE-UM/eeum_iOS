import Foundation

public enum PostUpdateAction: String {
    case completed
    case deleted
}

public extension Notification.Name {
    static let postDidUpdate = Notification.Name("postDidUpdate")
}
