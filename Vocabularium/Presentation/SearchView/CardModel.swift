//
//  CardModel.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 04.07.2021.
//

import Foundation

//struct Card: Identifiable {
//    var id: Int
//    var content: String
//    var definition: String
//    var translation: String?
//    var examples: [String]?
//    var notes: String?
//    var sources: [String]?
//    var tags: [String]?
//}


public struct Source2: Decodable {
    
    /// Уникальный идентификатор источника.
    public let id: Int
    
    /// Название источника.
    public let title: String
    
    /// Опциональная картинка источника.
    public let image: Data?
    
    /// Термины в данном источнике.
    public let terms: [Term2]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case terms
    }
}

public struct Example2: Decodable {
    
    /// Уникальный идентификатор примера.
    public let id: Int
    
    /// Тело примера.
    public let content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
    }
}

public struct Note: Decodable {
    
    /// Уникальный идентификатор заметки.
    public let id: Int
    
    /// Тело заметки.
    public let content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
    }
}

public struct Tag2: Decodable {
    
    /// Уникальный идентификатор тега.
    public let id: Int
    
    /// Наименование тега.
    public let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
}

public struct Language2: Decodable {
    
    /// Уникальный идентификатор языка.
    public let id: Int
    
    /// Название языка.
    public let name: String
    
    /// Код языка.
    public let code: String
    
    /// Код локали языка.
    public let localeCode: String
    
    /// Код языка, сджойненный с локалью.
    public let lcId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case localeCode
        case lcId
    }
}

public struct Term2: Decodable, Identifiable, Equatable {
    public static func == (lhs: Term2, rhs: Term2) -> Bool {
        lhs.id == rhs.id
    }
    
    
    /// Уникальный идентификатор термина.
    public let id: Int
    
    /// Содержимое термина.
    public let content: String
    
    /// Значение термина.
    public let meaning: String
    
    /// Перевод термина.
    public let translation: String
    
    /// Дата добавления термина.
    public let date: Date
    
    /// Источник, из которого пользователь взял термин.
    public let source: Source2
    
    /// Примеры для термина.
    public let examples: [Example2]
    
    /// Заметки для термина.
    public let notes: [Note]
    
    /// Теги для термина.
    public let tags: [Tag2]
    
    /// Тип термина (его название в языке: существительное, прилагательное, фраза, etc).
    public let type: String
    
    /// Язык, к которому пользователь прикрепил этот термин.
    public let language: Language2
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case meaning
        case translation
        case date
        case source
        case examples
        case notes
        case tags
        case type
        case language
    }
}

extension Term2 {
    func valueByPropertyName(name:String) -> [String] {
        switch name {
        case "content": return [content]
        case "definitions": return [meaning]
        case "translations": return [translation]
        case "examples":
            var output = [String]()
            for example in examples {
                output.append(example.content)
            }
            return output
        case "notes":
            var output = [String]()
            for note in notes {
                output.append(note.content)
            }
            return output
        case "sources": return [source.title]
        case "tags":
            var output = [String]()
            for tag in tags {
                output.append(tag.title)
            }
            return output
        default: fatalError("Wrong property name")
        }
    }
}
