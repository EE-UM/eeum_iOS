import SwiftUI

public extension Font {
    // MARK: - Pretendard
    static func pretendard(size: CGFloat, weight: PretendardWeight = .regular) -> Font {
        return .custom(weight.fontName, size: size)
    }

    // MARK: - Helvetica
    static func helvetica(size: CGFloat, weight: HelveticaWeight = .regular) -> Font {
        return .custom(weight.fontName, size: size)
    }
}

// MARK: - Pretendard Weights
public enum PretendardWeight {
    case thin
    case extraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black

    var fontName: String {
        switch self {
        case .thin: return "Pretendard-Thin"
        case .extraLight: return "Pretendard-ExtraLight"
        case .light: return "Pretendard-Light"
        case .regular: return "Pretendard-Regular"
        case .medium: return "Pretendard-Medium"
        case .semiBold: return "Pretendard-SemiBold"
        case .bold: return "Pretendard-Bold"
        case .extraBold: return "Pretendard-ExtraBold"
        case .black: return "Pretendard-Black"
        }
    }
}

// MARK: - Helvetica Weights
public enum HelveticaWeight {
    case regular
    case bold

    var fontName: String {
        switch self {
        case .regular: return "Helvetica"
        case .bold: return "Helvetica-Bold"
        }
    }
}
