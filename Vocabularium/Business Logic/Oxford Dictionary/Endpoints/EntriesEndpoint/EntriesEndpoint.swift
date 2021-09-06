//
//  EntriesEndpoint.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 8/27/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import Alamofire

final class ProcessingError: Error {
    var message = ""
    
    convenience init(message: String = "Unhandled error") {
        self.init()
         
        self.message = message
    }
}

extension OxfordDictionaryService.EntriesEndpoint {
    
    static func getFields(fields: [OxfordDictionaryField] = [.all],
                          forWord word: String,
                          inLanguage language: TranslationLanguage,
                          completion: @escaping (Result<EntriesResponse, Error>) -> Void) {
        
        guard word.count > 0 else {
            let error = ProcessingError(message: "The word is of zero length")
            print(error.message)
            completion(.failure(error))
            return
        }
        
        let headers = HTTPHeaders([
            "app_id": "b3411d87",
            "app_key": "ca662baea7dbfac99852e84ada040d15"
        ])
        
        let parameterizedURL = buildUrlString(withFields: fields, forWord: word, andLang: language)
        
        AF.request(parameterizedURL,
                   method: .get,
                   headers: headers).responseDecodable { (response: DataResponse<EntriesResponse, AFError>) in
            do {
                let entriesResponse = try JSONDecoder().decode(EntriesResponse.self, from: response.data ?? Data())
                completion(.success(entriesResponse))
            } catch let jsonError {
                print("Failed to decode \(response.description)", jsonError)
                completion(.failure(jsonError))
            }
        }
    }
    
    private static func buildUrlString(withFields fields: [OxfordDictionaryField], forWord word: String, andLang lang: TranslationLanguage) -> String {
        let langString = "/" + lang.rawValue
        let wordString = ("/" + word.lowercased()).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let fieldsString = fields.contains(.all) ? nil : "?fields=\(fields.map{ $0.rawValue }.joined(separator: "&"))"
        return OxfordDictionaryService.EntriesEndpoint.particularURL + [langString, wordString, fieldsString].compactMap{$0}.joined()
    }
}
