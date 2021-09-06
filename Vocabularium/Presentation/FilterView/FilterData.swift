//
//  FilterData.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 14.07.2021.
//

import Foundation

var filterTypes = [
    FilterType(id: 0, name: "content", shortName: "Content", isToggled: true),
    FilterType(id: 1, name: "definitions", shortName: "Definitions", isToggled: true),
    FilterType(id: 2, name: "translations", shortName: "Translations", isToggled: true),
    FilterType(id: 3, name: "examples", shortName: "Examples", isToggled: false),
    FilterType(id: 4, name: "notes", shortName: "Notes", isToggled: false),
    FilterType(id: 5, name: "sources", shortName: "Sources", isToggled: true),
    FilterType(id: 6, name: "tags", shortName: "Tags", isToggled: true),
]

var sections = [
    SectionDataModel(id: 0, text: "Search by:", isExpended: true),
    SectionDataModel(id: 1, text: "Sort by:", isExpended: true)
]
