//
//  CardMiniView.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 25.07.2021.
//

import SwiftUI

protocol IsCardSwipedDelegate {
    func swipeFinished(isKnown: Bool)
}

struct CardMiniView: View {
    
    var delegate: IsCardSwipedDelegate
    
    @State var location: CGPoint
    @State var rotation: Angle = .zero
    @State var tapRotation: Angle = .zero
    @State var contentRotation: Angle = .zero
    @State var isFlipped: Bool = false
        
    var card: Term2
    
    var simpleDrag: some Gesture {
        
            DragGesture()
                .onChanged { value in
                    
                    self.location.x = value.location.x
                    self.rotation.degrees = Double(location.x - 205) / 6
                }
                .onEnded { value in
                    switch location.x {
                    case ..<100:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            delegate.swipeFinished(isKnown: false)
                            self.location.x = 205
                            self.rotation.degrees = Double.random(in: -5...5)
                        }
                        withAnimation(Animation.linear(duration: 0.5)) {
                            self.location.x = -200
                            self.rotation.degrees = Double(location.x - 205) / 6
                        }
                        break
                    case 300...:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            delegate.swipeFinished(isKnown: true)
                        }
                        withAnimation(Animation.linear(duration: 0.5)) {
                            self.location.x = 700
                            self.rotation.degrees = Double(location.x - 205) / 6
                        }
                        
                        break
                        
                    default:
                        self.location.x = 205
                        self.rotation = .zero
                    }
                    
                }
        }
    
    func flipFlashcard() {
        let animationTime = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime / 2) {
            isFlipped.toggle()
        }
        withAnimation(Animation.linear(duration: animationTime)) {
            tapRotation.degrees += 180
        }
        
        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)){
            contentRotation.degrees += 180
            //isFlipped.toggle()
        }
        
    }
    
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .frame(width: 318, height: 495, alignment: .center)
                .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.25), radius: 5, x: 2, y: 2)
            
            VStack {
                // Добавить отображение кода
                Text(card.language.name).font(.title3).padding(.top, 10.0)
                Spacer()
                
                let text = isFlipped ? card.translation : card.content
                
                Text(text)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 25.0)
                    .padding(.trailing, 15.0/*@END_MENU_TOKEN@*/)
                
                Spacer()
                Text("Tap to flip the card").foregroundColor(Color.gray).padding(.trailing, 15.0).frame(maxWidth: .infinity, alignment: .center).padding([.leading, .bottom], 10.0)
            }
            
            .frame(width: 338, height: 505, alignment: .center)
        }
        .rotation3DEffect(tapRotation,  axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(rotation,  axis: (x: 0, y: 0, z: 1))
        .position(location)
        .gesture(simpleDrag)
        .onTapGesture {
                    flipFlashcard()
                }
            .rotation3DEffect(tapRotation, axis: (x: 0, y: 1, z: 0))
    }
    
}

struct CardMiniView_Previews: PreviewProvider {
    static var previews: some View {
        CardMiniView(delegate: LearningView.self as! IsCardSwipedDelegate, location: CGPoint(x: 200, y: 300), rotation: Angle(degrees: 0), card: cards[0])
    }
}
