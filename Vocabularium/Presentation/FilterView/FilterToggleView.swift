//
//  SearchByView.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 14.07.2021.
//

import SwiftUI

struct FilterToggleView: View {
    @State var filter: FilterType
    
    var body: some View {
        HStack {
            Toggle("Filter", isOn: $filter.isToggled)
                .onReceive([$filter.isToggled].publisher.first()) { (value) in
                        switchToggle()
                   }
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.9333333333333333, green: 0.803921568627451, blue: 0.13333333333333333)))
                
            Text(filter.name)
            Spacer()
        }
    }
    
    func switchToggle() {
        for i in 0...6 {
            if filterTypes[i].id == filter.id {
                filterTypes[i].isToggled = filter.isToggled
            }
        }
    }
    
}

struct FilterToggleView_Previews: PreviewProvider {
    static var previews: some View {
        FilterToggleView(filter: filterTypes[0])
    }
}
