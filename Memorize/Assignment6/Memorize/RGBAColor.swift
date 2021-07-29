//
//  RGBAColor.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 29.07.2021.
//

import SwiftUI

struct RGBAColor: Codable, Equatable, Hashable {
     let red: Double
     let green: Double
     let blue: Double
     let alpha: Double
}

extension Color {
    init(rgbaColor rgba: RGBAColor) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
     }
    
}

extension RGBAColor {
    init(color: Color) {
         var red: CGFloat = 0
         var green: CGFloat = 0
         var blue: CGFloat = 0
         var alpha: CGFloat = 0
         if let cgColor = color.cgColor {
            UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
         }
         self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}
