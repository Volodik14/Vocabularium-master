//
//  String+Ext.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 9/5/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

extension String {
    
    func quoted(forLang lang: TranslationLanguage) -> String {
        guard
            let bQuote = Locale.init(identifier: lang.localeCode).quotationBeginDelimiter,
            let eQuote = Locale.init(identifier: lang.localeCode).quotationEndDelimiter
            else { return self }
        
        return bQuote + self + eQuote
    }
    
// MARK: - Cap Letters
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
