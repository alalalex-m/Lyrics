public extension LyricsProviderSource {
    var localizedName: String {
        return NSLocalizedString(rawValue, bundle: .current, comment: "")
    }
}

extension Bundle {
    private class Placeholder {}
    static let current = Bundle(for: Placeholder.self)
}
