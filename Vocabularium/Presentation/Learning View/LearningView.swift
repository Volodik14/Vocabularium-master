//
//  LearningView.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 25.07.2021.
//

import SwiftUI

struct LearningView: View, IsCardSwipedDelegate {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

        var btnBack: some View {
            Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 18, height: 10)
                    .foregroundColor(.black)
            }
        }
    
    func swipeFinished(isKnown: Bool) {
        let card = cards.popLast()
        count -= 1
        if !isKnown {
            cards.insert(card!, at: 0)
            count += 1
        }
            
    }
    
    @State var cards: [Term2]
    @State var count: Int
    
    
    var maxCount: Int
    var startDate: Date
    var endDate: Date
    // Возможно уберу коллекцию
    
    var body: some View {
        VStack {
            Text("words from")
            Text("\(dateToString(date: startDate)) to \(dateToString(date: endDate))")
                .fontWeight(.bold)
            
            Text("\(maxCount - count)/\(maxCount)")
                .font(.title)
                .padding(.top, 50.0)
            Spacer()
            ZStack {
                ForEach(0..<count) { index in
                    if index < count {
                        CardMiniView(delegate: self, location: CGPoint(x: 210, y: 300), rotation: Angle(degrees: Double.random(in: -5...5)), card: cards[index])
                    }
                        
                }
                
            }
            
        }
        .padding(.top, 50.0)
        .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: btnBack)
        
    }
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        LearningView(cards: cards, count: cards.count, maxCount: cards.count, startDate: Date(), endDate: Date())
    }
}

func dateToString(date: Date) -> String {
    let dateFormatterMonth = DateFormatter()
    dateFormatterMonth.dateFormat = "MMMM"
    let dateFormatterDay = DateFormatter()
    dateFormatterDay.dateFormat = "dd"
    let month = dateFormatterMonth.string(from: date)
    let day = dateFormatterDay.string(from: date)
    return "\(month) \(day)"
}
