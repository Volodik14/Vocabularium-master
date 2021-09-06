//
//  Sense.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 8/27/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

struct Sense: Decodable {
    let id: String
    let definitions: [String]?
    let shortDefinitions: [String]?
    let examples: [Example]?
    let synonyms: [Synonym]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case definitions = "definitions"
//        case shortDefinitions = "shortDefinitions"
//        case examples = "examples"
//        case synonyms = "synonyms"
//    }
}

struct Example: Decodable {
    let text: String
}

struct Synonym: Decodable {
    let language: String
    let text: String
}
