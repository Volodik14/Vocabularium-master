//
//  TranslationResponse.swift
//  The Write-Down Dictionary
//
//  Created by Parshakov Alexander on 7/2/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

struct TranslationResponse: Decodable {
    
    let translations: [Translation]
    
    
    enum CodingKeys: String, CodingKey {
        case translations = "translations"
    }
}


struct Translation: Decodable {
    let text: String
    let detectedLanguageCode: String
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case detectedLanguageCode = "detectedLanguageCode"
    }
}
