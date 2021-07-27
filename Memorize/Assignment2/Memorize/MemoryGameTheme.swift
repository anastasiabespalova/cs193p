//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 17.07.2021.
//

import Foundation

struct Theme<CardContent> {
    
    let setOfContent: Array<CardContent>
    let numberOfPairs: Int
    let colorOfTheme: String
    let nameOfTheme: String
    let randomNumberOfPairs: Bool
    
    func returnContentForTheGame() -> Array<CardContent>{
        let shuffledArray = setOfContent.shuffled()
        var uniqueRandomContentForGame: Array<CardContent> = []
        for pairIndex in 0..<numberOfPairs {
            uniqueRandomContentForGame.append(shuffledArray[pairIndex])
        }
        return uniqueRandomContentForGame
    }
    
    // init with Theme
    init(theme: Theme<CardContent>) {
        self.numberOfPairs = theme.randomNumberOfPairs ? Int.random(in: 1..<theme.setOfContent.count) : theme.setOfContent.count
        self.randomNumberOfPairs = theme.randomNumberOfPairs
        self.setOfContent = theme.setOfContent
        self.colorOfTheme = theme.colorOfTheme
        self.nameOfTheme = theme.nameOfTheme
    }
    
    // init with numberOfPairs without randomNumberOfPairs
    init(setOfContent: Array<CardContent>, numberOfPairs: Int, colorOfTheme: String, nameOfTheme: String) {
        self.numberOfPairs = numberOfPairs > setOfContent.count ? setOfContent.count : numberOfPairs
        self.setOfContent = setOfContent
        self.colorOfTheme = colorOfTheme
        self.nameOfTheme = nameOfTheme
        self.randomNumberOfPairs = false
        
    }
    
    // init without numberOfPairs, randomNumberOfPairs
    init(setOfContent: Array<CardContent>, colorOfTheme: String, nameOfTheme: String) {
        self.numberOfPairs = setOfContent.count
        self.setOfContent = setOfContent
        self.colorOfTheme = colorOfTheme
        self.nameOfTheme = nameOfTheme
        self.randomNumberOfPairs = false
        
    }
    
    // init with randomNumberOfPairs, without numberOfPairs
    init(setOfContent: Array<CardContent>, randomNumberOfPairs: Bool, colorOfTheme: String, nameOfTheme: String) {
        self.numberOfPairs = randomNumberOfPairs ? Int.random(in: 1..<setOfContent.count) : setOfContent.count
        self.randomNumberOfPairs = true
        self.setOfContent = setOfContent
        self.colorOfTheme = colorOfTheme
        self.nameOfTheme = nameOfTheme
        
    }
    
    // init with all arguments
    init(setOfContent: Array<CardContent>, numberOfPairs: Int, colorOfTheme: String, nameOfTheme: String, randomNumberOfPairs: Bool) {
        if randomNumberOfPairs {
            self.numberOfPairs = Int.random(in: 1..<setOfContent.count)
        }
        else {
            self.numberOfPairs = numberOfPairs
        }
        self.setOfContent = setOfContent
        self.colorOfTheme = colorOfTheme
        self.nameOfTheme = nameOfTheme
        self.randomNumberOfPairs = randomNumberOfPairs
        
    }
    
}
