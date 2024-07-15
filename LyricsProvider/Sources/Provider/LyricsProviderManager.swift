import Foundation

public class LyricsProviderManager {
    
    let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    public init() {}
    
    public func searchLyrics(withRequest request: LyricsSearchRequest,
                             sources: [LyricsProviderSource] = LyricsProviderSource.allCases,
                             updateHandler: @escaping (Lyrics) -> Void) -> Progress
    {
        let progress = Progress(totalUnitCount: Int64(sources.count))
        for source in sources {
            let provider = source.cls.init(session: session)
            let childProgress = provider.lyricsTask(request: request, using: updateHandler)
            progress.addChild(childProgress, withPendingUnitCount: 1)
        }
        return progress
    }
}
