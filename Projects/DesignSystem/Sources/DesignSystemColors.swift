import SwiftUI
import UIKit

public extension Color {
    /// Initializes a Color using a hex string such as "#FFAA00" or "FFAA00".
    init(hex: String, alpha: Double = 1.0) {
        self.init(UIColor(hex: hex, alpha: alpha))
    }

    /// Primary brand color used throughout the app.
    static let mainBackground = Color(hex: "F5F4F0", alpha: 1.0)
    static let contentBackground = Color(hex: "EAE8E0")
    static let accentPrimary = Color(hex: "C33D32")
    
    static let textPrimary = Color(hex: "1D1D1D")
    static let textFootnote = Color(hex: "8A8A8A")
}

public extension UIColor {
    convenience init(hex: String, alpha: Double = 1.0) {
        let sanitized = hex
            .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            .uppercased()

        var rgbValue: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&rgbValue)

        let r, g, b: CGFloat
        switch sanitized.count {
        case 6:
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255
            b = CGFloat(rgbValue & 0x0000FF) / 255
        case 8:
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255
        default:
            r = 1
            g = 1
            b = 1
        }

        self.init(red: r, green: g, blue: b, alpha: alpha.clamped())
    }
}

private extension Double {
    func clamped() -> CGFloat {
        CGFloat(min(max(self, 0), 1))
    }
}
