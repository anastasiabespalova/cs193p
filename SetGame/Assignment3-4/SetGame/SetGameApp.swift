//
//  SetGameApp.swift
//  SetGame
//
//  Created by Анастасия Беспалова on 19.07.2021.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = ShapesSetGame()
    
    var body: some Scene {
        WindowGroup {
            ShapesSetGameView(game: game)
        }
    }
}
