//
//  Enums.swift
//  Vocabularium
//
//  Created by Parshakov Alexander on 8/27/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

enum GradientColor {
    case amin
    case stellar
    case rainbowBlue
    case deepSpace
    case zinc
    
    var cgColors: [CGColor] {
        switch self {
        case .amin:
            return Constants.Colors.UIGradientSets.amin.map { $0.cgColor }
        case .stellar:
            return Constants.Colors.UIGradientSets.stellar.map { $0.cgColor }
        case .rainbowBlue:
            return Constants.Colors.UIGradientSets.rainbowBlue.map { $0.cgColor }
        case .deepSpace:
            return Constants.Colors.UIGradientSets.deepSpace.map { $0.cgColor }
        case .zinc:
            return Constants.Colors.UIGradientSets.zinc.map { $0.cgColor }
        }
    }
    
    var colors: [UIColor] {
        switch self {
        case .amin:
            return Constants.Colors.UIGradientSets.amin
        case .stellar:
            return Constants.Colors.UIGradientSets.stellar
        case .rainbowBlue:
            return Constants.Colors.UIGradientSets.rainbowBlue
        case .deepSpace:
            return Constants.Colors.UIGradientSets.deepSpace
        case .zinc:
            return Constants.Colors.UIGradientSets.zinc
        default:
            return Constants.Colors.UIGradientSets.zinc
        }
    }
}

enum OxfordDictionaryField: String {
    case all = "all"
    case definitions = "definitions"
    case shortDefinitions = "shortDefinitions"
    case examples = "examples"
    case pronunciations = "pronunciations"
    case registers = "registers"
}

enum EnumLexicalCategory: String {
    case noun = "noun"
    case verb = "verb"
    case adjective = "adjective"
}

enum TranslationLanguage: String, CaseIterable {
    case americanEnglish = "en-us"
    case britainEnglish = "en-br"
    case russian = "ru"
    case french = "fr"
    case german = "de"
    case spanish = "es"
    case unknown = "--"
    
    var fullname: String {
        switch self {
        case .americanEnglish:
            return "English (US)"
        case .britainEnglish:
            return "English (UK)"
        case .russian:
            return "Russian"
        case .french:
            return "French"
        case .german:
            return "German"
        case .spanish:
            return "Spanish"
        case .unknown:
            return "unknown"
        }
    }
    
    var localeCode: String {
        switch self {
        case .americanEnglish:
            return "en_US"
        case .britainEnglish:
            return "en_GB"
        case .russian:
            return "ru_RU"
        case .french:
            return "fr_FR"
        case .german:
            return "de_DE"
        case .spanish:
            return "es_ES"
        case .unknown:
            return "unknown"
        }
    }
    
    static var allCasesSorted: [TranslationLanguage] = {
        return TranslationLanguage.allCases.filter{ $0 != .unknown}.sorted{ $0.fullname < $1.fullname }
    }()
}
