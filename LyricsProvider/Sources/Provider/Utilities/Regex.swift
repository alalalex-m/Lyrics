import Foundation

// MARK: MatchResult

struct MatchResult {
    
    struct Capture: Equatable, Hashable {
        let range: NSRange
        let content: Substring
        
        var string: String {
            return String(content)
        }
    }
    
    let captures: [Capture?]
    
    fileprivate init(result: NSTextCheckingResult, in string: String) {
        guard result.range.location != NSNotFound else {
            captures = []
            return
        }
        captures = (0..<result.numberOfRanges).map { index in
            let nsrange = result.range(at: index)
            guard nsrange.location != NSNotFound else { return nil }
            guard let r = Range(nsrange, in: string) else {
                // FIXME: regex detected an invalid position.
                return Capture(range: nsrange, content: "")
            }
            return Capture(range: nsrange, content: string[r])
        }
    }
}

extension MatchResult {
    
    var range: NSRange {
        return captures.first!!.range
    }
    
    var content: Substring {
        return captures.first!!.content
    }
    
    var string: String {
        return String(content)
    }
    
    subscript(_ captureGroupIndex: Int) -> Capture? {
        return captures[captureGroupIndex]
    }
}

// MARK: Regex

struct Regex {
    
    private let _regex: NSRegularExpression
    
    init(_ pattern: String, options: NSRegularExpression.Options = []) throws {
        _regex = try NSRegularExpression(pattern: pattern, options: options)
    }
}

extension Regex {
    
    var pattern: String {
        return _regex.pattern
    }
    
    var options: NSRegularExpression.Options {
        return _regex.options
    }
    
    var numberOfCaptureGroups: Int {
        return _regex.numberOfCaptureGroups
    }
    
    static func escapedPattern(for string: String) -> String {
        return NSRegularExpression.escapedPattern(for: string)
    }
}

extension Regex {
    
    func enumerateMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange? = nil, using block: (_ result: MatchResult?, _ flags: NSRegularExpression.MatchingFlags, _ stop: inout Bool) -> Void) {
        _regex.enumerateMatches(in: string, options: options, range: range ?? string.entireRange) { result, flags, stop in
            let r = result.map { MatchResult(result: $0, in: string) }
            var s = false
            block(r, flags, &s)
            stop.pointee = ObjCBool(s)
        }
    }
    
    func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange? = nil) -> [MatchResult] {
        return _regex.matches(in: string, options: options, range: range ?? string.entireRange).map {
            MatchResult(result: $0, in: string)
        }
    }
    
    func numberOfMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange? = nil) -> Int {
        return _regex.numberOfMatches(in: string, options: options, range: range ?? string.entireRange)
    }
    
    func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange? = nil) -> MatchResult? {
        return _regex.firstMatch(in: string, options: options, range: range ?? string.entireRange).map {
            MatchResult(result: $0, in: string)
        }
    }
    
    func isMatch(string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange? = nil) -> Bool {
        return _regex.firstMatch(in: string, options: options, range: range ?? string.entireRange) != nil
    }
}

// MARK: Conformances

extension MatchResult: Equatable, Hashable {
    
    static func == (lhs: MatchResult, rhs: MatchResult) -> Bool {
        return lhs.captures.elementsEqual(rhs.captures, by: ==)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(captures)
    }
}

extension Regex: Equatable, Hashable {
    
    static func == (lhs: Regex, rhs: Regex) -> Bool {
        return lhs._regex == rhs._regex
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_regex)
    }
}

// MARK: -

extension String {
    
    fileprivate var entireRange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
}

private func hashCombine(seed: Int, value: Int) -> Int {
    func hashCombine32(seed: inout UInt32, value: UInt32) {
        seed ^= (value &+ 0x9e3779b9 &+ (seed<<6) &+ (seed>>2))
    }
    func hashCombine64(seed: inout UInt64, value: UInt64) {
        let mul: UInt64 = 0x9ddfea08eb382d69
        var a = (value ^ seed) &* mul
        a ^= (a >> 47)
        var b = (seed ^ a) &* mul
        b ^= (b >> 47)
        seed = b &* mul
    }
    
    if MemoryLayout<Int>.size == 64 {
        var us = UInt64(UInt(bitPattern: seed))
        let uv = UInt64(UInt(bitPattern: value))
        hashCombine64(seed: &us, value: uv)
        return Int(truncatingIfNeeded: Int64(bitPattern: us))
    } else {
        var us = UInt32(UInt(bitPattern: seed))
        let uv = UInt32(UInt(bitPattern: value))
        hashCombine32(seed: &us, value: uv)
        return Int(truncatingIfNeeded: Int32(bitPattern: us))
    }
}
