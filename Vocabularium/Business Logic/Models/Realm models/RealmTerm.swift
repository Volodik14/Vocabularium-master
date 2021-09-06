////
////  RealmTerm.swift
////  Vocabularium
////
////  Created by Parshakov Alexander on 6/29/20.
////  Copyright © 2020 ParshakovAlexander. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//class RealmTerm: Object {
//    
//    @objc dynamic var id: String = ""
//    @objc dynamic var content: String = ""
//    @objc dynamic var meaning: String = ""
//    @objc dynamic var examples: [String] = []
//    @objc dynamic var note: String = ""
//    @objc dynamic var source: RealmTermSource?
//    @objc dynamic var lang: RealmLanguage?
//    @objc dynamic var dateCreated: String = ""
//    var tags: List<RealmTermTag> = List<RealmTermTag>()
//    var types: List<RealmTermType> = List<RealmTermType>()
//    
//    
//    convenience init(wordUnit: Term) {
//        self.init()
//        self.id = String(wordUnit.id)
//        self.content = wordUnit.content
//        self.meaning = wordUnit.meaning
//        self.examples = wordUnit.examples
//        self.note = wordUnit.note
//        if let date = wordUnit.dateCreated {
//            self.dateCreated = date
//        }
//        self.source = RealmTermSource(source: wordUnit.source)
//        
//        wordUnit.tags.forEach { (tag) in
//            self.tags.append(RealmTermTag(tag: tag))
//        }
//        wordUnit.types.forEach { (type) in
//            self.types.append(RealmTermType(type: type))
//        }
////        guard let date = wordUnit.dateCreated else { return }
////        self.dateCreated = date
//    }
//}
