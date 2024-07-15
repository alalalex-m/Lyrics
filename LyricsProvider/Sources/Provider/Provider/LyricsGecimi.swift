import Foundation

private let gecimiLyricsBaseURL = URL(string: "http://gecimi.com/api/lyric")!
private let gecimiCoverBaseURL = URL(string:"http://gecimi.com/api/cover")!

public final class LyricsGecimi: _LyricsProvider {
    
    public static let source: LyricsProviderSource = .gecimi
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func searchTask(request: LyricsSearchRequest, completionHandler: @escaping ([GecimiResponseSearchResult.Result]) -> Void) -> Progress {
        guard case let .info(title, artist) = request.searchTerm else {
            // cannot search by keyword
            completionHandler([])
            return Progress.completedProgress()
        }
        let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .uriComponentAllowed)!
        let encodedArtist = artist.addingPercentEncoding(withAllowedCharacters: .uriComponentAllowed)!
        
        let url = gecimiLyricsBaseURL.appendingPathComponent("\(encodedTitle)/\(encodedArtist)")
        let req = URLRequest(url: url)
        return session.startDataTask(with: req, type: GecimiResponseSearchResult.self) { model, error in
            completionHandler(model?.result ?? [])
        }
    }
    
    func fetchTask(token: GecimiResponseSearchResult.Result, completionHandler: @escaping (Lyrics?) -> Void) -> Progress {
        return session.startDataTask(with: token.lrc) { data, resp, error in
            guard let data = data,
                let lrcContent = String(data: data, encoding: .utf8),
                let lrc = Lyrics(lrcContent) else {
                completionHandler(nil)
                return
            }
            lrc.metadata.remoteURL = token.lrc
            lrc.metadata.source = .gecimi
            lrc.metadata.providerToken = "\(token.aid),\(token.lrc)"
            
            let url = gecimiCoverBaseURL.appendingPathComponent("\(token.aid)")
            let task = self.session.dataTask(with: url, type: GecimiResponseCover.self) { model, error in
                if let model = model {
                    lrc.metadata.artworkURL = model.result.cover
                }
            }
            task.resume()
            
            completionHandler(lrc)
        }
    }
}
