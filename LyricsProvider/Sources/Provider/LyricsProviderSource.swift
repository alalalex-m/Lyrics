import Foundation

public enum LyricsProviderSource: String, CaseIterable {
    case netease
    case qq
    case kugou
    case xiami
    case gecimi
    case viewLyrics
    case syair
}

extension LyricsProviderSource {
    
    var cls: LyricsProvider.Type {
        switch self {
        case .netease:  return LyricsNetEase.self
        case .qq:       return LyricsQQ.self
        case .kugou:    return LyricsKugou.self
        case .xiami:    return LyricsXiami.self
        case .gecimi:   return LyricsGecimi.self
        case .viewLyrics: return ViewLyrics.self
        case .syair:    return LyricsSyair.self
        }
    }
}
