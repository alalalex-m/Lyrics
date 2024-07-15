public extension UIColor {
    
    static let kjy_systemBackground: UIColor = {
        guard #available(iOS 13, *) else { return .white }
        return .systemBackground
    }()
    
    static let kjy_label: UIColor = {
        guard #available(iOS 13, *) else { return .darkText }
        return .label
    }()
    
    static let kjy_secondaryLabel: UIColor = {
        guard #available(iOS 13, *) else {
            return UIColor(red: 0.235294, green: 0.235294, blue: 0.262745, alpha: 0.6)
        }
        return .secondaryLabel
    }()
}
