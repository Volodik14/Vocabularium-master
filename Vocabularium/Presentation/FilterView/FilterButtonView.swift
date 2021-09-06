//
//  ButtonView.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 14.07.2021.
//

import SwiftUI


struct FilterButtonView: View {
    
    @State private var isActive = false
    
    var body: some View {
        HStack {
            Button(action: {
                //Open filter view
                isActive = true
                
            }, label: {
                Image("Vector")
                    .font(.system(.largeTitle))
                    .frame(width: 55, height: 55)
                    .foregroundColor(Color.black)
            })
            .background(Color.white)
            .cornerRadius(15)
            .padding()
            .shadow(color: Color.black.opacity(0.3),
                    radius: 3,
                    x: 3,
                    y: 3)
            NavigationLink(destination: FilterView(sections: sections), isActive: $isActive) { }
        }
        
    }
}

struct FilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonView()
    }
}




