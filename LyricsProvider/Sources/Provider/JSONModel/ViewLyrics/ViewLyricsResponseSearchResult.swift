import Foundation

struct ViewLyricsResponseSearchResult: Decodable {
    
    let link: String
    let artist: String
    let title: String
    let album: String
    let uploader: String?
    let timelength: Int?
    let rate: Double?
    let ratecount: Int?
    let downloads: Int?
}
