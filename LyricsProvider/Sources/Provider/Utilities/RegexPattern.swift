import Foundation

private let id3TagPattern = "^(?!\\[[+-]?\\d+:\\d+(?:\\.\\d+)?\\])\\[(.+?):(.+)\\]$"
let id3TagRegex = try! Regex(id3TagPattern, options: .anchorsMatchLines)

private let krcLinePattern = "^\\[(\\d+),(\\d+)\\](.*)"
let krcLineRegex = try! Regex(krcLinePattern, options: .anchorsMatchLines)

private let netEaseInlineTagPattern = "\\(0,(\\d+)\\)([^(]+)(\\(0,1\\) )?"
let netEaseInlineTagRegex = try! Regex(netEaseInlineTagPattern)

private let kugouInlineTagPattern = "<(\\d+),(\\d+),0>([^<]*)"
let kugouInlineTagRegex = try! Regex(kugouInlineTagPattern)

private let ttpodXtrcLinePattern = "^((?:\\[[+-]?\\d+:\\d+(?:\\.\\d+)?\\])+)(?:((?:<\\d+>[^<\\r\\n]+)+)|(.*))$(?:[\\r\\n]+\\[x\\-trans\\](.*))?"
let ttpodXtrcLineRegex = try! Regex(ttpodXtrcLinePattern, options: .anchorsMatchLines)

private let ttpodXtrcInlineTagPattern = "<(\\d+)>([^<\\r\\n]+)"
let ttpodXtrcInlineTagRegex = try! Regex(ttpodXtrcInlineTagPattern)

private let syairSearchResultPattern = "<div class=\"title\"><a href=\"([^\"]+)\">"
let syairSearchResultRegex = try! Regex(syairSearchResultPattern)

private let syairLyricsContentPattern = "<div class=\"entry\">(.+?)<div"
let syairLyricsContentRegex = try! Regex(syairLyricsContentPattern, options: .dotMatchesLineSeparators)
