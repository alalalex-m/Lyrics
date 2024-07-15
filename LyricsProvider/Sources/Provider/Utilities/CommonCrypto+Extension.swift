import Foundation
import CommonCrypto

func md5(_ string: String) -> Data {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    digestData.withUnsafeMutableBytes { digestBytes in
        messageData.withUnsafeBytes { messageBytes in
            _ = CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    return digestData
}
