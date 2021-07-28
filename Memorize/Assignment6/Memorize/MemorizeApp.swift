//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 14.07.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
