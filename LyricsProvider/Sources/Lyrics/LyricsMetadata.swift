import Foundation

extension Lyrics.MetaData.Key {
    public static var source        = Lyrics.MetaData.Key("source")
    public static var attachmentTags = Lyrics.MetaData.Key("attachmentTags")
}

extension Lyrics.MetaData {
    
    public var source: LyricsProviderSource? {
        get { return data[.source] as? LyricsProviderSource }
        set { data[.source] = newValue }
    }
    
    public var attachmentTags: Set<LyricsLine.Attachments.Tag> {
        get { return data[.attachmentTags] as? Set<LyricsLine.Attachments.Tag> ?? [] }
        set { data[.attachmentTags] = newValue }
    }
    
    public var hasTranslation: Bool {
        return attachmentTags.contains { tag in
            tag.isTranslation
        }
    }
}
