//
//  ThemeStore.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 29.07.2021.
//

import SwiftUI

struct ThemeForEmojis: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var color: RGBAColor
    var numberOfPairs: Int
    var id: Int
    
    fileprivate init(name: String, emojis: String, color: RGBAColor, numberOfPairs: Int, id: Int) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfPairs = numberOfPairs
        self.id = id
    }
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [ThemeForEmojis]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "ThemeStore: " + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
//        UserDefaults.standard.set(palettes.map { [$0.name,$0.emojis,String($0.id)]}, forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<ThemeForEmojis>.self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    init(named name: String) {
            self.name = name
            restoreFromUserDefaults()
            if themes.isEmpty {
                print("using built-in themes")
                insertTheme(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻", color: RGBAColor(color: Color.red), numberOfPairs: 6)
                insertTheme(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾", color: RGBAColor(color: Color.blue), numberOfPairs: 5)
                insertTheme(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", color: RGBAColor(color: Color.yellow), numberOfPairs: 9)
                insertTheme(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙", color: RGBAColor(color: Color.red), numberOfPairs: 3)
                insertTheme(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰", color: RGBAColor(color: Color.orange), numberOfPairs: 5)
                insertTheme(named: "COVID", emojis: "💉🦠😷🤧🤒", color: RGBAColor(color: Color.purple), numberOfPairs: 5)
            } else {
                print("successfully loaded themes from UserDefaults")
            }
        }
        
        // MARK: - Intent
        
        func theme(at index: Int) -> ThemeForEmojis {
            let safeIndex = min(max(index, 0), themes.count - 1)
            return themes[safeIndex]
        }
        
        @discardableResult
        //is the Swift attribute discardableResult use to suppress the "Result unused" warning.
        func removePalette(at index: Int) -> Int {
            if themes.count > 1, themes.indices.contains(index) {
                themes.remove(at: index)
            }
            return index % themes.count
        }
        
    func insertTheme(named name: String, emojis: String? = nil, color: RGBAColor, numberOfPairs: Int, at index: Int = 0) {
            let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
            let theme = ThemeForEmojis(name: name, emojis: emojis ?? "", color: color, numberOfPairs: numberOfPairs, id: unique)
            let safeIndex = min(max(index, 0), themes.count)
            themes.insert(theme, at: safeIndex)
        }
        
    }
