import Foundation
import UIKit

enum Fonts {
    case satoshiBlack
    case satoshiRegular
    case satoshiBold
    case satoshiLight
    case satoshiMedium

    var fontName: String {
        switch self {
        case .satoshiBlack:
            return "Satoshi-Black"
        case .satoshiRegular:
            return "Satoshi-Regular"
        case .satoshiBold:
            return "Satoshi-Bold"
        case .satoshiLight:
            return "Satoshi-Light"
        case .satoshiMedium:
            return "Satoshi-Medium"
        }
    }
}


extension UIFont {
    // TODO
    
    static func appFont(size: CGFloat,fontName:Fonts) -> UIFont {
        return UIFont(name: fontName.fontName, size: size) ?? UIFont()
    }
    
    static func fontAndSize(size: CGFloat, fontName: String) -> UIFont {
        return UIFont(name: fontName, size: size)
        ?? UIFont.systemFont(ofSize: size)
    }
}

