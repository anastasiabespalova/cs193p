//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Анастасия Беспалова on 23.07.2021.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
