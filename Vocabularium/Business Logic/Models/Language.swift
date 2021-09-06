//
//  Language.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 6/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation


final class Language: NSObject, NSSecureCoding, Decodable, Encodable {
    static var supportsSecureCoding: Bool = true
    
    
    var id: Int
    var name: String
    var location: String
    
    override init() {
        self.id = 0
        self.name = ""
        self.location = ""
    }
    
//    convenience init (realmLanguage: RealmLanguage) {
//        self.init()
//        self.id = Int(realmLanguage.id)!
//        self.name = realmLanguage.name
//        self.location = realmLanguage.location
//    }
    convenience init (id: Int, name: String, location: String) {
        self.init()
        self.id = id
        self.name = name
        self.location = location
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let location = aDecoder.decodeObject(forKey: "location") as! String

        self.init(id: id, name: name, location: location)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(location, forKey: "location")
    }
}
