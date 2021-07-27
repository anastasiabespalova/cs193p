//
//  ShapesSetGame.swift
//  SetGame
//
//  Created by Анастасия Беспалова on 19.07.2021.
//

import SwiftUI


class ShapesSetGame: ObservableObject {
    typealias Card = Game.Card
    var isMatched: Bool? {
        return model.isMatched
    }
    var hintIndex: Int? {
        return model.currentHintIndex
    }
    var currentSolutions: [[Card]] {
        return model.currentSolutions.arrayOfSolutions
    }
    
    var score: Int {
        return model.score
    }
    
    var areAnyCardsInDeck: Bool {
        return model.haveCardsInDeck
    }
    
    var cardsOnTable: Array<Card> {
        model.cardsOnTable
    }
    
    var cardsInDeck: Array<Card> {
        model.cardsInDeck
    }
    
    var cardsFromSets: Array<Card> {
        model.cardsFromSets
    }
    

    
    
    @Published private var model = Game()
    
    //MARK: -Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card: card)
    }
    
    func dealThreeMoreCards() {
        model.dealThreeMoreCards()
    }
    
    func hint() {
        model.hint()
    }
    
    func createSetGame() {
        model = Game()
    }
    
    func clearSetGame() {
        model.clear()
    }

}
