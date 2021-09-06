//
//  OxfordDictionaryResponse.swift
//  The Write-Down Dictionary
//
//  Created by Parshakov Alexander on 8/23/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

struct EntriesResponse: Decodable {
    let id: String
    let metadata: Metadata
    let results: [EntriesResult]
    let word: String
}

struct Metadata: Decodable {
    let operation: String
    let provider: String
    let schema: String
}

struct EntriesResult: Decodable {
    let id: String
    let language: String
    let lexicalEntries: [LexicalEntry]
    let type: String
    let word: String
    
    
    func lexicalEntriesCounts() -> String? {
        guard lexicalEntries.count > 0 else { return nil }
        
        var resultStrings = [String]()
        
        lexicalEntries.forEach { (lexicalEntry) in
            if let senses = lexicalEntry.entries.first?.senses {
                let lexicalEntriesCountString = "\(lexicalEntry.lexicalCategory.text): \(senses.count)"
                resultStrings.append(lexicalEntriesCountString)
            }
        }
        
        return resultStrings.joined(separator: "\n")
    }
}


