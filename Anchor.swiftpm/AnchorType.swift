//
//  AnchorType.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import Foundation
import SwiftUI

enum AnchorType: String, CaseIterable {
    case migraine = "Migraine"
    case panicAttack = "Panic Attack"
    
    var color: Color {
        switch self {
        case .migraine:
            return .migraineTint
        case .panicAttack:
            return .indigo
        }
    }
}

extension Color {
    /// A function that dynamically updates the color based on `userInterfaceStyle`
    static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
        let uiColor = UIColor { $0.userInterfaceStyle == .light ? light : dark }
        
        return Color(uiColor: uiColor)
    }
    
    static func dynamicColor(light: Color, dark: Color) -> Color {
        dynamicColor(light: UIColor(light), dark: UIColor(dark))
    }
    
    // MARK: Custom Colors
    // Because Swift Playgrounds doesn't support ColorSets
    
    static var migraineTint: Self {
        dynamicColor(light: #colorLiteral(red: 0, green: 0.6205425858, blue: 0.3912295103, alpha: 1), dark: #colorLiteral(red: 0.178935051, green: 0.8115785718, blue: 0, alpha: 1))
    }
    
    static var homeCircleGradientColor1: Self {
        dynamicColor(light: #colorLiteral(red: 0.771538496, green: 0.731972754, blue: 0.654540062, alpha: 1), dark: #colorLiteral(red: 0.7647058824, green: 0.7333333333, blue: 0.662745098, alpha: 1))
    }
    
    static var homeCircleGradientColor2: Self {
        dynamicColor(light: #colorLiteral(red: 0.7500734925, green: 0.5939528346, blue: 0.5971903801, alpha: 1), dark: #colorLiteral(red: 0.7254901961, green: 0.6, blue: 0.6, alpha: 1))
    }
    
    static var homeCircleGradientColor3: Self {
        dynamicColor(light: #colorLiteral(red: 0.8365617394, green: 0.6227167249, blue: 0.7561656237, alpha: 1), dark: #colorLiteral(red: 0.6709461808, green: 0.5728670955, blue: 0.7410820127, alpha: 1))
    }
    
    static var homeCircleGradientColor4: Self {
        dynamicColor(light: #colorLiteral(red: 0.5211637616, green: 0.452409029, blue: 0.5901052356, alpha: 1), dark: #colorLiteral(red: 0.7559938431, green: 0.8822496533, blue: 0.9571806788, alpha: 1))
    }
    
    static var homeAntiCircleGradientColor1: Self {
        dynamicColor(light: #colorLiteral(red: 0.5657837391, green: 0.6617270112, blue: 0.7242951989, alpha: 1), dark: #colorLiteral(red: 0.7339206934, green: 0.8142710924, blue: 0.9451389909, alpha: 1))
    }
    
    static var homeAntiCircleGradientColor2: Self {
        dynamicColor(light: #colorLiteral(red: 0.5455493331, green: 0.6058027148, blue: 0.7071407437, alpha: 1), dark: #colorLiteral(red: 0.5568627451, green: 0.6039215686, blue: 0.6980392157, alpha: 1))
    }
}
