//
//  Term.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

struct TermResults: Decodable, Encodable {
    var results: [Term]
}


struct Term: Decodable, Encodable {
    
    var id: Int
    var content: String
    var meaning: String
    var examples: [String]
    var note: String
    var dateCreated: String?
    var tags: [Tag]
    var source: Source
    var types: [TermType]
    var lang: Language
    
    
    init() {
        id = 0
        content = ""
        meaning = ""
        examples = []
        note = ""
        tags = [Tag]()
        source = Source()
        lang = Language()
        types = [TermType]()
    }
//    init(realmWordUnit: RealmTerm) {
//        self.init()
//        self.id = Int(realmWordUnit.id)!
//        self.content = realmWordUnit.content
//        self.meaning = realmWordUnit.meaning
//        self.examples = realmWordUnit.examples
//        self.note = realmWordUnit.note
//        
//        if let source = realmWordUnit.source
//        {
//            self.source = Source(realmWordSource: source)
//        }
//        
//        realmWordUnit.tags.forEach { (realmWordTag) in
//            self.tags.append(Tag(realmWordTag: realmWordTag))
//        }
//    }
}

extension Term {
    func isTagRelevant(content search:String) -> Bool {
        for tag in tags {
            if tag.name.lowercased().contains(search.lowercased()) {
                return true
            }
        }
        return false
    }
}
