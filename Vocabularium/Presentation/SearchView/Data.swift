//
//  Data.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 04.07.2021.
//

import Foundation

let english = Language2(id: 0, name: "English", code: "EN", localeCode: "EN", lcId: "0")

let cards2 = [
    Term2(id: 0, content: "Hello", meaning: "Welcoming somebody", translation: "Привет", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Hello, my friend!")], notes: [Note(id: 0, content: "Note 1")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
    Term2(id: 1, content: "Good night", meaning: "Kind words before bed", translation: "Спокойной ночи!", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Good night, sweet prince!")], notes: [Note(id: 1, content: "Note 2")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
]

let cards = [
    Term2(id: 0, content: "Memorandum", meaning: "a written message in business or diplomacy", translation: "Меморандум", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Hello, my friend!")], notes: [Note(id: 0, content: "Note 1")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
    Term2(id: 1, content: "To amble over", meaning: "to walk in a slow, leisurely way", translation: "Идти медленно", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Good night, sweet prince!")], notes: [Note(id: 1, content: "Note 2")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
    Term2(id: 2, content: "Hello", meaning: "Welcoming somebody", translation: "Привет", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Hello, my friend!")], notes: [Note(id: 0, content: "Note 1")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
    Term2(id: 3, content: "Good night", meaning: "Kind words before bed", translation: "Спокойной ночи!", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Good night, sweet prince!")], notes: [Note(id: 1, content: "Note 2")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
    Term2(id: 4, content: "Cacophony", meaning: "a harsh, unpleasant mixture of noise", translation: "Какофония", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Hello, my friend!")], notes: [Note(id: 0, content: "Note 1")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
    Term2(id: 5, content: "Cognizant", meaning: "being aware or having knowledge of something", translation: "Боязнь знаний!", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Good night, sweet prince!")], notes: [Note(id: 1, content: "Note 2")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
    Term2(id: 6, content: "Garbled", meaning: "communication that is distorted and unclear", translation: "Плохая, испорченная (связь)", date: Date(), source: Source2(id: 0, title: "Source 1", image: nil, terms: nil), examples: [Example2(id: 0, content: "Hello, my friend!")], notes: [Note(id: 0, content: "Note 1")], tags: [Tag2(id: 0, title: "Basic")], type: "Type 1", language: english),
]



