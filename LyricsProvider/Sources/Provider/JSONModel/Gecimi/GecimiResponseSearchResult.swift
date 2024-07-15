import Foundation

struct GecimiResponseSearchResult: Decodable {
    let result: [Result]
    
    /*
    let count: Int
    let code: Int
     */
    
    struct Result: Decodable {
        let lrc: URL
        let aid: Int
        
        /*
        let sid: Int
        let artist_id: Int
        let song: String
         */
    }
}
