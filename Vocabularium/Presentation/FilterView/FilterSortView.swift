//
//  FilterSortVIew.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 15.07.2021.
//

import SwiftUI

struct FilterSortView: View {
    @State var filter: FilterType
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 0.7 * UIScreen.screenWidth - 8 + 10, height: 41, alignment: .center)
                .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.25), radius: 5, x: 2, y: 2)
            HStack {
                Text(filter.shortName)
                    .padding(.leading, 30.0)
                Spacer()
            }
            
        }.frame(width: 0.7 * UIScreen.screenWidth + 10, height: 48, alignment: .center)
        
    }
}

struct FilterSortView_Previews: PreviewProvider {
    static var previews: some View {
        FilterSortView(filter: filterTypes[0])
    }
}
