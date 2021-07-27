//
//  SetGame.swift
//  SetGame
//
//  Created by Анастасия Беспалова on 19.07.2021.
//

import Foundation

// GameModel

struct Game {
    private (set) var cardsInDeck: Array<Card> = []
    private (set) var cardsOnTable: Array<Card> = []
    private (set) var cardsFromSets: Array<Card> = []
    
    private (set) var haveCardsInDeck = true
    private (set) var isMatched: Bool? = nil
    private let initCardNumber = 12
    private (set) var currentSolutions = Solution()
    private (set) var currentHintIndex: Int? = nil
    
    private (set) var score: Int = 0
    
    private var startTime: DispatchTime?
    private var endTime: DispatchTime?
    
    mutating func choose(card: Card) {
        currentHintIndex = nil
        currentSolutions.arrayOfSolutions = []
        
        let chosenIndex = cardsOnTable.firstIndex(where: {$0.id == card.id})!
        print(cardsOnTable[chosenIndex].cardContent)
        
        if cardsOnTable[chosenIndex].isChosen {
            if cardsOnTable.filter({$0.isChosen == true}).count < 3 {
                cardsOnTable[chosenIndex].isChosen.toggle()
            } else {
                return
            }
        } else {
            switch cardsOnTable.filter({$0.isChosen == true}).count {
            case 0, 1:
                cardsOnTable[chosenIndex].isChosen = true
            case 2:
                cardsOnTable[chosenIndex].isChosen = true
                if checkMatching(selectedCards: cardsOnTable.filter({$0.isChosen == true})) {
                    endTime = DispatchTime.now()
                    score += max(
                        15 - Int(Double(endTime!.uptimeNanoseconds - startTime!.uptimeNanoseconds)/1_000_000_000),
                        1)
                    isMatched = true
                    startTime = DispatchTime.now()
                } else {
                    startTime = DispatchTime.now()
                    score -= 5
                    isMatched = false
                }
            case 3:
                if isMatched == true {
                    if cardsOnTable[chosenIndex].isChosen {
                        // выбранная карта - часть set
                        return
                    } else {
                        /*if haveCardsInDeck {
                            for _ in 0..<3 {
                                let matchingCardId = cardsOnTable.firstIndex(where: {$0.isChosen == true})!
                                cardsFromSets.append(cardsOnTable.remove(at: matchingCardId))
                                cardsOnTable.insert(cardsInDeck.remove(at: Int.random(in: 0..<cardsInDeck.count)), at: matchingCardId)
                            }
                            isMatched = nil
                            cardsOnTable[cardsOnTable.firstIndex(where: {$0.id == card.id})!].isChosen = true
                            if cardsInDeck.count == 0 {
                                haveCardsInDeck = false
                            }
                        } else { */
                            for _ in 0..<3 {
                                let matchingCardId = cardsOnTable.firstIndex(where: {$0.isChosen == true})!
                                cardsFromSets.append(cardsOnTable.remove(at: matchingCardId))
                            }
                            isMatched = nil
                            cardsOnTable[cardsOnTable.firstIndex(where: {$0.id == card.id})!].isChosen = true
                        //}
                    }
                } else {
                    for _ in 0..<3 {
                        let matchingCardId = cardsOnTable.firstIndex(where: {$0.isChosen == true})!
                        cardsOnTable[matchingCardId].isChosen.toggle()
                    }
                    isMatched = nil
                    cardsOnTable[chosenIndex].isChosen = true
                }
            default:
                isMatched = nil
                return
            }
        }
    }
    
    func checkMatching(selectedCards: Array<Game.Card>) -> Bool {
        var colorSum = 0
        var quantitySum = 0
        var shapeSum = 0
        var fillmentSum = 0
        selectedCards.forEach( {
            colorSum += $0.cardContent.color.rawValue
            quantitySum += $0.cardContent.quantity.rawValue
            shapeSum += $0.cardContent.shape.rawValue
            fillmentSum += $0.cardContent.fillment.rawValue
        })
        //print("\(colorSum) + \(quantitySum) + \(shapeSum) + \(fillmentSum)")
        return colorSum % 3 == 0 && quantitySum % 3 == 0 && shapeSum % 3 == 0 && fillmentSum % 3 == 0 ? true : false
    }
    
    mutating func dealThreeMoreCards() {
        currentHintIndex = nil
        currentSolutions.arrayOfSolutions = []
        if cardsOnTable.filter({$0.isChosen == true}).count == 3 && isMatched == true {
            for _ in 0..<3 {
                let matchingCardId = cardsOnTable.firstIndex(where: {$0.isChosen == true})!
                cardsFromSets.append(cardsOnTable.remove(at: matchingCardId))
                cardsOnTable.insert(cardsInDeck.remove(at: Int.random(in: 0..<cardsInDeck.count)), at: matchingCardId)
                isMatched = nil
            }
        } else {
            findAllSolutions()
            startTime = DispatchTime.now()
            if currentSolutions.countSolutions > 0 {
                score -= 5
            }
            for _ in 0..<3 {
                cardsOnTable.append(cardsInDeck.remove(at: Int.random(in: 0..<cardsInDeck.count)))
            }
        }
        if cardsInDeck.count == 0 {
            haveCardsInDeck = false
        }
        
    }

    mutating func findAllSolutions() {
        let comb = CombinationsWithRepetition(of: cardsOnTable, length: 3)
        for cards in comb {
            if cards[0].id != cards[2].id &&
                cards[0].id  != cards[1].id &&
                cards[1].id != cards[2].id {
                if checkMatching(selectedCards: cards) == true {
                    currentSolutions.arrayOfSolutions.append(cards)
                }
            }
        }
        
    }
    
    mutating func clear() {
        for index in 0..<cardsOnTable.count {
            cardsFromSets.append(cardsOnTable.remove(at: index))
        }
    }
    
    mutating func hint() {
        startTime = DispatchTime.now()
        findAllSolutions()
        if currentSolutions.countSolutions == 0 {
            return
        } else {
            score -= 5
            if currentHintIndex != nil {
                currentHintIndex! += 1 % currentSolutions.countSolutions
            } else {
               // findAllSolutions()
                currentHintIndex = 0
            }
        }
        
    }
    
    init() {
        cardsInDeck.removeAll()
        cardsOnTable.removeAll()
        startTime = DispatchTime.now()
        
        var currentIndex = 0
        CardColor.allCases.forEach {color in
            Quantity.allCases.forEach {quantity in
                Shapes.allCases.forEach {shape in
                    Fillment.allCases.forEach {fillment in
                        cardsInDeck.append(Card(id: currentIndex, with: CardContent(color: color, quantity: quantity, shape: shape, fillment: fillment)))
                        currentIndex += 1
                    }
                }
            }
        }
        for _ in 0..<initCardNumber {
            let randomCard = cardsInDeck.randomElement()!
            cardsOnTable.append(randomCard)
            cardsInDeck.remove(at: cardsInDeck.firstIndex { $0.id == randomCard.id}!)
        }
    }
    
    struct Card: Identifiable {
        let cardContent: CardContent
        var isChosen = false
        let id: Int
        init(id: Int, with cardContent: CardContent) {
            self.id = id
            self.cardContent = cardContent
        }
        
    }
    
    struct Solution {
        var arrayOfSolutions: [Array<Card>] = []
        var countSolutions: Int {
            arrayOfSolutions.count
        }
    }
    
}

struct CombinationsWithRepetition<C: Collection> : Sequence {

    let base: C
    let length: Int

    init(of base: C, length: Int) {
        self.base = base
        self.length = length
    }

    struct Iterator : IteratorProtocol {
        let base: C

        var firstIteration = true
        var finished: Bool
        var positions: [C.Index]

        init(of base: C, length: Int) {
            self.base = base
            finished = base.isEmpty
            positions = Array(repeating: base.startIndex, count: length)
        }

        mutating func next() -> [C.Element]? {
            if firstIteration {
                firstIteration = false
            } else {
                // Update indices for next combination.
                finished = true
                for i in positions.indices.reversed() {
                    base.formIndex(after: &positions[i])
                    if positions[i] != base.endIndex {
                        finished = false
                        break
                    } else {
                        positions[i] = base.startIndex
                    }
                }

            }
            return finished ? nil : positions.map { base[$0] }
        }
    }

    func makeIterator() -> Iterator {
        return Iterator(of: base, length: length)
    }
}


