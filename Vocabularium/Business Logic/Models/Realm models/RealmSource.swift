////
////  RealmSource.swift
////  Vocabularium
////
////  Created by Parshakov Alexander on 6/29/20.
////  Copyright © 2020 ParshakovAlexander. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//class RealmSource: Object {
//    
//    
//    @objc dynamic var id: String = ""
//    @objc dynamic var name: String = ""
//    @objc dynamic var imageData: Data = Data()
//    var realmWordUnits: List<RealmTerm> = List<RealmTerm>()
//    
//    convenience init(source: Source) {
//        self.init()
//        
//        self.id = String(source.id)
//        self.name = source.name
//        guard let imageData = source.imageData else { return }
//        self.imageData = imageData
//        
//        source.wordUnits?.forEach({ (wordUnit) in
//            let realmWordUnit = RealmTerm(wordUnit: wordUnit)
//            self.realmWordUnits.append(realmWordUnit)
//        })
//    }
//}
