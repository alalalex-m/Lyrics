import Foundation

private let kugouSearchBaseURLString = "http://lyrics.kugou.com/search"
private let kugouLyricsBaseURLString = "http://lyrics.kugou.com/download"

public final class LyricsKugou: _LyricsProvider {
    
    public static let source: LyricsProviderSource = .kugou
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func searchTask(request: LyricsSearchRequest, completionHandler: @escaping ([KugouResponseSearchResult.Item]) -> Void) -> Progress {
        let parameter: [String: Any] = [
            "keyword": request.searchTerm.description,
            "duration": Int(request.duration * 1000),
            "client": "pc",
            "ver": 1,
            "man": "yes",
            ]
        let url = URL(string: kugouSearchBaseURLString + "?" + parameter.stringFromHttpParameters)!
        return session.startDataTask(with: url, type: KugouResponseSearchResult.self) { model, error in
            completionHandler(model?.candidates ?? [])
        }
    }
    
    func fetchTask(token: KugouResponseSearchResult.Item, completionHandler: @escaping (Lyrics?) -> Void) -> Progress {
        let parameter: [String: Any] = [
            "id": token.id,
            "accesskey": token.accesskey,
            "fmt": "krc",
            "charset": "utf8",
            "client": "pc",
            "ver": 1,
            ]
        let url = URL(string: kugouLyricsBaseURLString + "?" + parameter.stringFromHttpParameters)!
        return session.startDataTask(with: url, type: KugouResponseSingleLyrics.self) { model, error in
            guard let model = model,
                let lrcContent = decryptKugouKrc(model.content),
                let lrc = Lyrics(kugouKrcContent: lrcContent) else {
                    completionHandler(nil)
                    return
            }
            lrc.idTags[.title] = token.song
            lrc.idTags[.artist] = token.singer
            lrc.idTags[.lrcBy] = "Kugou"
            
            lrc.length = Double(token.duration)/1000
            lrc.metadata.source = .kugou
            lrc.metadata.providerToken = "\(token.id),\(token.accesskey)"
            
            completionHandler(lrc)
        }
    }
}
