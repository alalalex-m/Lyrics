import Foundation

struct GecimiResponseCover: Decodable {
    let result: Result
    
    /*
    let count: Int
    let code: Int
     */
    
    struct Result: Decodable {
        let cover: URL
        let thumb: URL
    }
}
