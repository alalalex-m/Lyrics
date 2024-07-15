public extension UIColor {
    /// match Apple Music
    static var globalTint: UIColor = {
        if #available(iOS 13, *) {
            return .systemPink
        }
        return UIColor(red: 1, green: 45/255, blue: 85/255, alpha: 1)
    }()
    
    static let highContrastiveGlobalTint = UIColor.kjy_label
}
