//
//  CardView.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 04.07.2021.
//

import SwiftUI

struct CardView: View {
    var card: Term2
    
    var search: String
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .frame(width: 318, height: 156, alignment: .center)
                .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.25), radius: 5, x: 2, y: 2)
            
            VStack {
                if findFilterState(id: 0) {
                    LabelColor(search: search, word: card.content).font(.title).padding(.top, 10.0).font(.title).padding(.top, 10.0)
                } else {
                    Text(card.content).font(.title).padding(.top, 10.0)
                }
                
                Spacer()
                if findFilterState(id: 1) {
                    LabelColor(search: search, word: card.meaning).multilineTextAlignment(.center)
                        .padding(.leading, 25.0)
                        .padding(.trailing, 15.0/*@END_MENU_TOKEN@*/)
                } else {
                    Text(card.meaning).multilineTextAlignment(.center)
                        .padding(.leading, 25.0)
                        .padding(.trailing, 15.0/*@END_MENU_TOKEN@*/)
                }
                
                Spacer()
                if findFilterState(id: 6) {
                    LabelColor(search: search, word: card.source.title).foregroundColor(Color.gray).padding(.trailing, 15.0).frame(maxWidth: .infinity, alignment: .trailing).padding(/*@START_MENU_TOKEN@*/[.bottom, .trailing], 10.0/*@END_MENU_TOKEN@*/)
                } else {
                    Text(card.source.title).foregroundColor(Color.gray).padding(.trailing, 15.0).frame(maxWidth: .infinity, alignment: .trailing).padding(/*@START_MENU_TOKEN@*/[.bottom, .trailing], 10.0/*@END_MENU_TOKEN@*/)
                }
            }.frame(width: 338, height: 166, alignment: .center)
        }
        
    }
    
    func findFilterState(id: Int) -> Bool {
        for i in 0...6 {
            if filterTypes[i].id == id {
                return filterTypes[i].isToggled
            }
        }
        return true
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
            CardView(card: cards[0], search: "e")
    }
}
