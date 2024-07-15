public extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.com.jonny.lyrics")!
}


@objc public extension UserDefaults {
    
    dynamic var disablesIdleTimer: Bool {
        get {
            if let value = value(forKey: "disablesIdleTimer") as? Bool {
                return value
            }
            self.disablesIdleTimer = false
            return false
        }
        set {
            set(newValue, forKey: "disablesIdleTimer")
        }
    }
    
    dynamic var showsLyricsTranslationIfAvailable: Bool {
        get {
            if let value = value(forKey: "showsLyricsTranslationIfAvailable") as? Bool {
                return value
            }
            self.showsLyricsTranslationIfAvailable = true
            return true
        }
        set {
            set(newValue, forKey: "showsLyricsTranslationIfAvailable")
        }
    }
    
    dynamic var maximumNotificationCount: Int {
        get {
            if let value = value(forKey: "maximumNotificationCount") as? Int {
                return value
            }
            self.maximumNotificationCount = 3
            return 3
        }
        set {
            set(newValue, forKey: "maximumNotificationCount")
        }
    }
    
    dynamic var allowsNowPlayingItemNotification: Bool {
        get {
            if let value = value(forKey: "allowsNowPlayingItemNotification") as? Bool {
                return value
            }
            self.allowsNowPlayingItemNotification = true
            return true
        }
        set {
            set(newValue, forKey: "allowsNowPlayingItemNotification")
        }
    }
    
    dynamic var prefersCenterAlignedLayout: Bool {
        get {
            if let value = value(forKey: "prefersCenterAlignedLayout") as? Bool {
                return value
            }
            self.prefersCenterAlignedLayout = false
            return false
        }
        set {
            set(newValue, forKey: "prefersCenterAlignedLayout")
        }
    }
    
    /// Use `MPMediaItem.kjy_userSpecifiedSources` to set and get actual value.
    fileprivate(set) dynamic var userSpecifiedLyricsByMediaIDs: [String : Any] {
        get {
            if let value = dictionary(forKey: "userSpecifiedLyricsByMediaIDs") {
                return value
            }
            self.userSpecifiedLyricsByMediaIDs = [:]
            return [:]
        }
        set {
            set(newValue, forKey: "userSpecifiedLyricsByMediaIDs")
        }
    }
}


public extension MPMediaItem {
    
    var kjy_userSpecifiedLyrics: Lyrics? {
        get {
            guard let rawLyrics = UserDefaults.appGroup.userSpecifiedLyricsByMediaIDs["\(persistentID)"] as? String,
                let lyrics = Lyrics(rawLyrics) else { return nil }
            return lyrics
        }
        set {
            UserDefaults.appGroup.userSpecifiedLyricsByMediaIDs["\(persistentID)"] = newValue?.description
        }
    }
}
