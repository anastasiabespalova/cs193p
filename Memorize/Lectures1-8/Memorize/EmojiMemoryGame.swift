//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 16.07.2021.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static var emojis = ["🚘", "🚝", "🚁", "🛶", "🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚜", "🛴", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔", "🚍", "🚖", "🚡", "🚃", "🚂", "🚊", "✈️", "🚀"]
 

    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 9) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    
    //MARK: -Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }

}
