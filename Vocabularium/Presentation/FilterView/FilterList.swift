//
//  FilterList.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 15.07.2021.
//

import SwiftUI

struct FilterList: View {
    
    
    init() {
            UITableView.appearance().tableFooterView = UIView()

        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
    }
    
    
    
    @State var editingList = true
    
    var body: some View {
        List(){
            ForEach(filterTypes){type in
                FilterSortView(filter: type)
                .lineLimit(7)
                //.listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .hideRowSeparator()
                    
                
                
            }
            .onMove(perform: move)
        }
        .environment(\.editMode, editingList ? .constant(.active) : .constant(.inactive))
        .background(Color.white)

    }
    
//    var body: some View {
//        List{
//            ForEach(filterTypes){type in
//                FilterSortView(filter: type)
//                .lineLimit(nil)
//
//
//            }.onMove(perform: move)
//
//        }
//
//        .environment(\.editMode, editingList ? .constant(.active) : .constant(.inactive))
//        .background(Color.clear)
//    }
    
    func move(fromOffsets source: IndexSet, toOffsets destination: Int) {
        filterTypes.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            //editingList = false
        }
    }
}

struct FilterList_Previews: PreviewProvider {
    static var previews: some View {
        FilterList()
    }
}
