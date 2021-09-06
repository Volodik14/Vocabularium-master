//
//  Entry.swift
//  The Write-Down Dictionary
//
//  Created by Parshakov Alexander on 8/27/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation

struct Entry: Decodable {
    let senses: [Sense]
}
