//
//  TranslationService.swift
//  The Write-Down Dictionary
//
//  Created by Parshakov Alexander on 7/2/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import Alamofire

protocol TranslationProtocol {
    func translate(word: String,
                   fromLanguage sourceLang: TranslationLanguage,
                   toLanguage targetLang: TranslationLanguage,
                   completion: @escaping (Result<TranslationResponse, Error>) -> Void)
}

final class TranslationService {
    private static let translateURL = "https://translate.api.cloud.yandex.net/translate/v2/translate"
    private init() {}
    
    
    
    static func translate(word: String,
                          fromLanguage sourceLang: TranslationLanguage,
                          toLanguage targetLang: TranslationLanguage,
                          completion: @escaping (Result<TranslationResponse, Error>) -> Void) {
        let headers = HTTPHeaders([
            "Authorization": "Api-Key AQVNxfslffb44WciDry9j_eAmfkja9ONVNQ0dr2W"
        ])
        
        let parameters: [String : Any] = [
            "texts" : [word],
            "sourceLanguageCode" : sourceLang,
            "targetLanguageCode" : targetLang
        ]
        
        AF.request("https://translate.api.cloud.yandex.net/translate/v2/translate",
                   method: .post,
                   parameters: parameters,
                   headers: headers).responseDecodable { (response: DataResponse<TranslationResponse, AFError>) in
            do {
                let translationResponse = try JSONDecoder().decode(TranslationResponse.self, from: response.data ?? Data())
                completion(.success(translationResponse))
            } catch let jsonError {
                print("Failed to decode \(response.description)", jsonError)
                completion(.failure(jsonError))
            }
        }
    }
}


