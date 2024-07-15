import Foundation

extension String {
    
    func decodingXMLEntities() -> String {
        #if os(macOS)
            return CFXMLCreateStringByUnescapingEntities(kCFAllocatorDefault, self as CFString, nil) as String
        #else
            // FIXME: low performance
            return String.xmlEntities.reduce(self) { $0.replacingOccurrences(of: $1.0, with: $1.1) }
        #endif
    }
    
    func encodingXMLEntities() -> String {
        #if os(macOS)
            return CFXMLCreateStringByEscapingEntities(kCFAllocatorDefault, self as CFString, nil) as String
        #else
            // FIXME: low performance
            return String.xmlEntities.reversed().reduce(self) { $0.replacingOccurrences(of: $1.1, with: $1.0) }
        #endif
    }
    
    static let xmlEntities = [
        "&quot;":   "\"",
        "&apos;":   "'",
        "&lt;":     "<",
        "&gt;":     ">",
        "&amp;":    "&",
        ]
}
