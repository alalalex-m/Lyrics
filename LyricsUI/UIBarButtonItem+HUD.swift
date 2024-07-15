public extension UIBarButtonItem {
    
    /// The title for VoiceOver and iOS 11 accessibility HUD view.
    var hudTitle: String? {
        get {
            return accessibilityLabel
        }
        set {
            accessibilityLabel = newValue
            if #available(iOS 11.0, *) {
                self.title = newValue
            }
        }
    }
}
