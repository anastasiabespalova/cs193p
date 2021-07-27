//
//  ContentView.swift
//  SetGame
//
//  Created by Анастасия Беспалова on 19.07.2021.
//

import SwiftUI

struct ShapesSetGameView: View {
    @Namespace private var dealingNamespace
    @ObservedObject var game: ShapesSetGame

    
    let settings = SymbolSettings()
    
    var body: some View {
       VStack {
            Spacer()
            HStack {
                Spacer()
                newGame
                Spacer()
                Text("Score: \(game.score)")
                Spacer()
              
            }
            
            Spacer()
            gameBody
            .padding()
            
            HStack {
                Spacer()
                discardBody
                Spacer()
                hint
                Spacer()
              //  if game.areAnyCardsInDeck { dealThreeMoreCards }
                deckBody
                Spacer()
                
            }
            .padding(.horizontal)
            
            
        }
    }
    
    var gameBody: some View {
        GeometryReader { geometry in
        AspectVGrid(items: game.cardsOnTable, aspectRatio: 4/5) {
            card in
            CardView(card: card, settings: settings, isMatched: game.isMatched, solutions: game.currentSolutions, hintIndex: game.hintIndex)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation(.linear(duration: 1)){
                            game.choose(card)
                        }
                           
                    }
                .transition(.offset(CGSize(width: -1000, height: -1000)))
                
        }
        .onAppear (perform: {
            withAnimation(.easeInOut(duration: 1)) {
                    game.createSetGame()
                }
            })
        .onDisappear(perform: {
            withAnimation(.easeInOut(duration: 1)) {
                game.clearSetGame()
            }
        }
        )
                
            }
            }
    
    
    private func dealAnimation(for card: ShapesSetGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cardsOnTable.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cardsOnTable.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cardsInDeck) { card in
               // CardView(card: card)
                CardView(card: card, settings: settings, isMatched: game.isMatched, solutions: game.currentSolutions, hintIndex: game.hintIndex)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
            let shape = RoundedRectangle(cornerRadius: 10)
            shape.fill().foregroundColor(.red)
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(.red)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1)){
            game.dealThreeMoreCards()
                }
        }
    }
    
    var discardBody: some View {
        ZStack {
            ForEach(game.cardsFromSets) { card in
                CardView(card: card, settings: settings, isMatched: game.isMatched, solutions: game.currentSolutions, hintIndex: game.hintIndex)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(.red)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1)){
            game.dealThreeMoreCards()
                }
        }
    }
    
    var hint: some View {
        Button(action: { withAnimation() {
            game.hint()
        } }, label: {
            VStack {
                Image(systemName: "questionmark.circle")
                Text("Hint")
            }
        })
    }
    
    var dealThreeMoreCards: some View {
        Button(action: { withAnimation {
                game.dealThreeMoreCards()
        } }, label: {
                VStack {
                    Image(systemName: "plus.circle")
                    Text("Deal 3")
                    Text("more cards")
                }
            })
    }
    
    var newGame: some View {
        Button(action:  { withAnimation(.easeInOut(duration: 1.5)){
            game.createSetGame()
        }
            
        } , label: {
            VStack {
                Image(systemName: "arrow.clockwise")
                Text("New game")
            }
        })
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth: CGFloat = undealtHeight * aspectRatio
        
    }
 
}


struct CardView: View {
    let card: ShapesSetGame.Card
    let settings: SymbolSettings
    let isMatched: Bool?
    let solutions: [[ShapesSetGame.Card]]
    let hintIndex: Int?
    
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(
                    lineWidth: DrawingConstants.lineWidth)
                    .foregroundColor(getStrokeColor())
                settings.returnContent(for: card).padding(10)
            }
                settings.isThereRoundedRectangle(for: card, cornerRadius: DrawingConstants.cornerRadius, isMatched: isMatched)
        })
    }
    
    func getStrokeColor() -> Color {
        if hintIndex != nil {
            let index = hintIndex
            if !(card.id != solutions[index!][0].id &&
                card.id != solutions[index!][1].id &&
                card.id != solutions[index!][2].id)
            {
                return .green
            }
        }
        if card.isChosen {
            return .yellow
        } else {
            return .gray
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2.5
        static let fontScale: CGFloat = 0.7
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapesSetGame()
        return ShapesSetGameView(game: game)
    }
}











