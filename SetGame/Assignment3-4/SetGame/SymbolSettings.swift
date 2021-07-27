//
//  SymbolSettings.swift
//  SetGame
//
//  Created by Анастасия Беспалова on 20.07.2021.
//

import SwiftUI

struct SymbolSettings {
    typealias Card = Game.Card
    
    func returnContent(for card: Card) -> some View {
        VStack {
            //Spacer()
            let quantity = getQuantity(of: card)
            ForEach(0..<quantity, id: \.self) {_ in
                getShape(of: card)
            }
        }.foregroundColor(getColor(of: card))
    }
    
    
    func getShape(of card: Card) -> some View {
        ZStack {
            switch card.cardContent.shape {
            case .v1: getFillment(of: card, shape: Diamond()).aspectRatio(CGSize(width: 6, height: 3), contentMode: .fit)
            case .v2: getFillment(of: card, shape: Capsule()).aspectRatio(CGSize(width: 6, height: 3), contentMode: .fit)
            //case .v3: getFillment(of: card, shape: Rectangle())
            case .v3: getFillment(of: card, shape: SquiggleShape()).aspectRatio(CGSize(width: 6, height: 3), contentMode: .fit)
            }
        }
    }
    
    func getFillment<setShape>(of card: Card, shape: setShape) -> some View where setShape: Shape {
        ZStack {
            switch card.cardContent.fillment {
            case .v1: shape.stroke()
            case .v2: shape.fillAndBorder()
            //case .v3: shape.halfFill()
            case .v3: shape.stripes()
            }
        }
    }
    
    func getColor(of card: Card) -> Color {
        switch card.cardContent.color {
        case .v1:
            return Color.red
        case .v2:
            return Color.green
        case .v3:
            return Color.blue
        }
    }

    func getQuantity(of card: Card) -> Int {
        switch card.cardContent.quantity {
        case .v1:
            return 1
        case .v2:
            return 2
        case .v3:
            return 3
        }
    }

    
    
    func isThereRoundedRectangle(for card: Card, cornerRadius: CGFloat, isMatched: Bool?) -> some View {
        
        guard let match = isMatched else {
            return RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.white).opacity(0.0)
        }
        if match == true && card.isChosen {
            return RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.green).opacity(0.5)
        } else if match == false && card.isChosen {
            return RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.red).opacity(0.5)
        }
        return RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.white).opacity(0.0)
    }
}

extension Shape {
    func stroke() -> some View {
        ZStack {
            self.stroke(lineWidth: 2.5)
        }
    }
    
    func fillAndBorder() -> some View {
        ZStack {
            self.fill()
            self.stroke(lineWidth: 2.5)
        }
    }
    
    func halfFill() -> some View {
        ZStack {
            self.fill().opacity(0.25)
            self.stroke(lineWidth: 2.5)
        }
    }
    
    func stripes() -> some View {
        ZStack{
            StripedRect().stroke().clipShape(self)
            self.stroke(lineWidth: 2.5)
        }
    }
}
