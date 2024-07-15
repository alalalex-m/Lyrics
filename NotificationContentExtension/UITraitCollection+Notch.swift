import UIKit

extension UITraitCollection {
    
    var kjy_displayNotched: Bool {
        return UITraitCollection.kjy_displayNotched
    }
    
    static let kjy_displayNotched: Bool = {
        #if targetEnvironment(macCatalyst)
        return false
        #else
        let screenBounds = UIScreen.main.bounds
        let width  = min(screenBounds.width, screenBounds.height)
        let height = max(screenBounds.width, screenBounds.height)
        return width / height < 0.55 // 9/16
        #endif
    }()
}
