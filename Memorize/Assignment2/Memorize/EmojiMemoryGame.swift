//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 16.07.2021.
//


// 3. Supportagradientasthe“color”foratheme.Hint:fill()cantakeaGradientasits argument rather than a Color. This is a “learning to look things up in the documentation” exercise.
// 4. Modify the scoring system to give more points for choosing cards more quickly. For example, maybe you get max(10 - (number of seconds since last card was chosen), 1) x (the number of points you would have otherwise earned or been penalized with). (This is just an example, be creative!). You will definitely want to familiarize yourself with the Date struct.

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private var setOfThemes = [
        Theme<String>(setOfContent: ["🚘", "🚝", "🚁", "🛶", "🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚜", "🛴", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔", "🚍", "🚖", "🚡", "🚃", "🚂", "🚊", "✈️", "🚀"],
                      numberOfPairs: 10,
                      colorOfTheme: "red",
                      nameOfTheme: "Vehicles"),
        
         Theme<String>(setOfContent: ["🐲", "🎃", "👻", "🍭", "🍬"],
                      colorOfTheme: "orange",
                      nameOfTheme: "Halloween"),
        
        Theme<String>(setOfContent: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻"],
                      numberOfPairs: 10,
                      colorOfTheme: "blue",
                      nameOfTheme: "Animals"),
        
        Theme<String>(setOfContent: ["🌵", "🎄", "🌲", "🌳", "🌴", "🌱", "🌿"],
                      randomNumberOfPairs: true,
                      colorOfTheme: "green",
                      nameOfTheme: "Plants")
    ]
    
    init() {
        let currentTheme = Theme<String>(theme: setOfThemes.randomElement()!)
        let uniqueContent = currentTheme.returnContentForTheGame()
        
        model = MemoryGame<String>(numberOfPairsOfCards: currentTheme.numberOfPairs) { pairIndex in
            uniqueContent[pairIndex]
        }
        currentThemeModel = currentTheme
    }

    @Published private var model: MemoryGame<String>
    @Published private var currentThemeModel: Theme<String>
    
    var cards: Array<Card> {
        model.cards
    }
    
    
    //MARK: -Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func createMemoryGame() {
        let currentTheme = Theme<String>(theme: setOfThemes.randomElement()!)
        let uniqueContent = currentTheme.returnContentForTheGame()
        
        model = MemoryGame<String>(numberOfPairsOfCards: currentTheme.numberOfPairs) { pairIndex in
            uniqueContent[pairIndex]
        }
        currentThemeModel = currentTheme
    }
    
    
    
    func getContentColor () -> Color {
        switch currentThemeModel.colorOfTheme {
        case "red":
            return .red
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "green":
            return .green
        case "yellow":
            return .yellow
        default:
            return .red
        }
    }
    
    func getThemeName () -> String {
        return currentThemeModel.nameOfTheme
    }
    
    func getScore () -> Int {
        return model.score
    }
}
