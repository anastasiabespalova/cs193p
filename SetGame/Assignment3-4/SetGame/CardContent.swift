//
//  CardsSettings.swift
//  SetGame
//
//  Created by Анастасия Беспалова on 19.07.2021.
//

import Foundation

enum CardColor: Int, CaseIterable {
    case v1 = 1
    case v2 = 2
    case v3 = 3
}

enum Quantity: Int, CaseIterable {
    case v1 = 1
    case v2 = 2
    case v3 = 3
}

enum Shapes: Int, CaseIterable {
    case v1 = 1
    case v2 = 2
    case v3 = 3
}

enum Fillment: Int, CaseIterable {
    case v1 = 1
    case v2 = 2
    case v3 = 3
}

struct CardContent {
    let color: CardColor
    let quantity: Quantity
    let shape: Shapes
    let fillment: Fillment

    
}

