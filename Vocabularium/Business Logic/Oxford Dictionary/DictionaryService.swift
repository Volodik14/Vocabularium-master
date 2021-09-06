//
//  DictionaryService.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 8/23/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import Alamofire

protocol EndpointProtocol {
    static var particularURL: String { get }
}

final class OxfordDictionaryService {
    private static let baseUrl = "https://od-api.oxforddictionaries.com/api/v2"
    private init() {}
    
    struct EntriesEndpoint: EndpointProtocol {
        static var particularURL: String {
            return OxfordDictionaryService.baseUrl + "/entries"
        }
    }
}


