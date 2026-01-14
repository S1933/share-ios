//
//  LinkMetadataService.swift
//  share
//
//  Created by Jean-Philippe Deis Nuel on 14/01/2026.
//

import Foundation
import NaturalLanguage

struct LinkMetadataService {
    
    static func fetchMetadata(for url: URL) async -> (title: String?, tags: [String]) {
        var title: String? = nil
        var tags: [String] = []
        
        // 1. Fetch Title
        if let (data, _) = try? await URLSession.shared.data(from: url),
           let html = String(data: data, encoding: .utf8) {
            
            // Simple regex to find <title>
            if let regex = try? NSRegularExpression(pattern: "<title>(.*?)</title>", options: .caseInsensitive),
               let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
               let range = Range(match.range(at: 1), in: html) {
                var extractedTitle = String(html[range]).trimmingCharacters(in: .whitespacesAndNewlines)
                // Decode HTML entities if needed (basic handling)
                extractedTitle = extractedTitle.replacingOccurrences(of: "&amp;", with: "&")
                    .replacingOccurrences(of: "&quot;", with: "\"")
                    .replacingOccurrences(of: "&#39;", with: "'")
                    .replacingOccurrences(of: "&lt;", with: "<")
                    .replacingOccurrences(of: "&gt;", with: ">")
                title = extractedTitle
            }
        }
        
        // Fallback to host if title is missing
        let textToAnalyze = title ?? url.host ?? ""
        
        // 2. Generate Tags using NaturalLanguage
        tags = generateTags(from: textToAnalyze)
        
        return (title, tags)
    }
    
    private static func generateTags(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass])
        tagger.string = text
        
        var tags: Set<String> = []
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                let word = String(text[tokenRange])
                // Keep Nouns and Proper Nouns
                if tag == .noun || tag == .otherWord {
                     if word.count > 2 { // Filter out short words
                         tags.insert(word.capitalized)
                     }
                }
            }
            return true
        }
        
        // Also look for specific named entities (Organizations, etc if useful)
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
             if let tag = tag, (tag == .organizationName || tag == .placeName || tag == .personalName) {
                 let word = String(text[tokenRange])
                 tags.insert(word.capitalized)
             }
             return true
         }

        return Array(tags).sorted()
    }
}
