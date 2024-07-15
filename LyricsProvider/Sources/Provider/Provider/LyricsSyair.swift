import Foundation

private let syairSearchBaseURLString = "https://syair.info/search"
private let syairLyricsBaseURL = URL(string: "https://syair.info")!

public final class LyricsSyair: _LyricsProvider {
    
    public static let source: LyricsProviderSource = .syair
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func searchTask(request: LyricsSearchRequest, completionHandler: @escaping ([String]) -> Void) -> Progress {
        var parameter: [String: Any] = ["page": 1]
        switch request.searchTerm {
        case let .info(title: title, artist: artist):
            parameter["artist"] = artist
            parameter["title"] = title
        case let .keyword(keyword):
            parameter["q"] = keyword
        }
        let url = URL(string: syairSearchBaseURLString + "?" + parameter.stringFromHttpParameters)!
        return session.startDataTask(with: url) { data, resp, error in
            guard let data = data,
                let str = String(data: data, encoding: .utf8) else {
                    completionHandler([])
                    return
            }
            let tokens = syairSearchResultRegex.matches(in: str).compactMap { ($0.captures[1]?.content).map(String.init) }
            completionHandler(tokens)
        }
    }
    
    func fetchTask(token: String, completionHandler: @escaping (Lyrics?) -> Void) -> Progress {
        guard let url = URL(string: token, relativeTo: syairLyricsBaseURL) else {
            completionHandler(nil)
            return Progress.completedProgress()
        }
        var req = URLRequest(url: url)
        req.addValue("https://syair.info/", forHTTPHeaderField: "Referer")
        return session.startDataTask(with: req) { data, resp, error in
            guard let data = data,
                let str = String(data: data, encoding: .utf8),
                let lrcData = syairLyricsContentRegex.firstMatch(in: str)?.captures[1]?.content.data(using: .utf8),
                let lrcString = try? NSAttributedString(data: lrcData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string,
                let lrc = Lyrics(lrcString) else {
                completionHandler(nil)
                return
            }
            
            lrc.metadata.source = .syair
            lrc.metadata.providerToken = token
            
            completionHandler(lrc)
        }
    }
}
