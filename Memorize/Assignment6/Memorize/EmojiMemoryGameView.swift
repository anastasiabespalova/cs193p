//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 14.07.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        VStack {
            Text(game.getThemeName())
                .font(.largeTitle)
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(game.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                }
            }
           // .foregroundColor(game.getContentColor())
            .foregroundColor(.red)
            .padding(.horizontal)
            
            Spacer()
            HStack {
                Text("Score: \(game.getScore())").font(.largeTitle)
                Spacer()
                Button(action: {
                    game.createMemoryGame(theme: game.currentThemeModel)
                }, label: {
                    VStack {
                        Image(systemName: "arrow.clockwise")
                        Text("New game")
                    }
                    
                })
            }
            .padding(.horizontal)
            
        }
        
    }

}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        ZStack() {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }

    }
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world")
       /* let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)*/
    }
}
