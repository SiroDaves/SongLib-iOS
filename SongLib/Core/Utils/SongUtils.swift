//
//  SongUtils.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

class SongUtils {
    static func searchSongs(
        songs: [Song],
        qry: String,
        byNo: Bool = false
    ) -> [Song] {
        
        let query = qry.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return songs }
        
        if byNo {
            if let number = Int(query) {
                return songs.filter { $0.songNo == number }
            } else {
                return []
            }
        }
        
        let charsPattern = try! NSRegularExpression(pattern: "[!,]", options: [])
        
        let words: [String]
        if query.contains(",") {
            words = query
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
        } else {
            words = [query.lowercased()]
        }
        
        let escapedWords = words.map { NSRegularExpression.escapedPattern(for: $0) }
        let pattern = escapedWords.joined(separator: ".*")
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        
        return songs.filter { song in
            let title = charsPattern.stringByReplacingMatches(
                in: song.title,
                range: NSRange(song.title.startIndex..., in: song.title),
                withTemplate: ""
            ).lowercased()
            
            let alias = charsPattern.stringByReplacingMatches(
                in: song.alias,
                range: NSRange(song.alias.startIndex..., in: song.alias),
                withTemplate: ""
            ).lowercased()
            
            let content = charsPattern.stringByReplacingMatches(
                in: song.content,
                range: NSRange(song.content.startIndex..., in: song.content),
                withTemplate: ""
            ).lowercased()
            
            let fields = [title, alias, content]
            return fields.contains { field in
                regex.firstMatch(in: field, range: NSRange(field.startIndex..., in: field)) != nil
            }
        }
    }
}
