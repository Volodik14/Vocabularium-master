//
//  FilterModel.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 14.07.2021.
//

import Foundation

struct FilterType: Identifiable {
    var id: Int
    var name: String
    var shortName: String
    var isToggled: Bool
}
