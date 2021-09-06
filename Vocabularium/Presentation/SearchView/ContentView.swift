//
//  ContentView.swift
//  SwiftUINoCoreData
//
//  Created by Владимир Моторкин on 03.07.2021.
//




import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

        var btnBack: some View {
            Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 18, height: 10)
                    .foregroundColor(.black)
            }
        }
    var cards: [Term2]
    
    @State private var searchString: String = ""
    @State private var showCancelButton: Bool = false
    
    var body: some View {

        //NavigationView {
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("search", text: $searchString, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchString = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchString == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if showCancelButton  {
                        Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchString = ""
                                self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly

                ScrollView {
                    // Filtered list of names
                    ForEach(filterCards(cards: cards, searchString: searchString)) { card in
                        CardView(card: card, search: searchString)
                    }
                }
                //.navigationBarTitle(Text("Search"))
                .resignKeyboardOnDragGesture()
            }
            .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        }
    
//    }
}


private func filterCards(cards: [Term2], searchString: String) -> [Term2] {
    if searchString == "" {
        return cards
    }
    
    let lowerCasedSearchString = searchString.lowercased()
    var filteredCards = [Term2]()
    for filterType in filterTypes {
        if filterType.isToggled {
            for card in cards {
                let fields = card.valueByPropertyName(name: filterType.name)
                for field in fields {
                    let lField = field.lowercased()
                    if lField.contains(lowerCasedSearchString) {
                        if !filteredCards.contains(card) {
                            filteredCards.append(card)
                            
                        }
                    }
                }
            }
        }
    }
    return filteredCards
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(cards: cards)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

