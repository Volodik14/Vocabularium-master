//
//  ContentView.swift
//  TestLabel
//
//  Created by Владимир Моторкин on 30.08.2021.
//

import SwiftUI

extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        let stringLowerCase = string.lowercased()
        let selfString = self.lowercased()
        var searchStartIndex = selfString.startIndex

        while searchStartIndex < selfString.endIndex,
            let range = selfString.range(of: stringLowerCase, range: searchStartIndex..<selfString.endIndex),
            !range.isEmpty
        {
            let index = distance(from: selfString.startIndex, to: range.lowerBound)
            var ind = index
            for _ in 0..<stringLowerCase.count {
                indices.append(ind)
                ind += 1
            }
            indices.append(index)
            searchStartIndex = range.upperBound
        }

        return indices
    }
}

struct LabelColor: View {
    var search: String = ""
    var word: String
    var body: some View {
        
        let letter = word.map( { String($0) } )
        
        let searchIndices = word.indicesOf(string: search)
        
        HStack(spacing: 0) {
            ForEach((0 ..< letter.count), id: \.self) { column in
                if (searchIndices.contains(column)) {
                    Text(letter[column]).foregroundColor(.red)
                } else {
                    Text(letter[column])
                }
                
                
            }
        }
        
    }
    
}

struct LabelColor_Previews: PreviewProvider {
    static var previews: some View {
        LabelColor(search: "l", word: "Hello")
    }
}
