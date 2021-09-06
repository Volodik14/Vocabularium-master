//
//  FilterView.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 14.07.2021.
//

import SwiftUI

struct FilterView: View {
    //@State private var editMode = EditMode.active
    @State var sections: [SectionDataModel]
    
    var body: some View {
        List {
            ForEach(0 ..< sections.count) { index in
                VStack() {
                    Button(action: {
                        onSectionClick(index: index)
                    }) {
                        HStack {
                            Text(sections[index].text)
                            Spacer()
                            if sections[index].isExpended {
                                Image(systemName: "chevron.down")
                                
                            } else {
                                Image(systemName: "chevron.up")
                            }
                        }
                        .frame(width: .infinity, height: 40)
                        .foregroundColor(.primary)
                    }
                    
                    
                    if sections[index].isExpended {
                        if sections[index].id == 0 {
                            ForEach(filterTypes) { type in
                                FilterToggleView(filter: type)
                            }
                        } else {
                            FilterList()
                                .frame(width: .infinity, height: 500, alignment: .top)
                        }
                        
                    }
                    
                }
            }
        }

    }
    
    
    private func onSectionClick( index:  Int) {
        sections[index].isExpended.toggle()
        print(sections[index].isExpended)
    }
    
    
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(sections: sections)
    }
}
