//
//  CustomColors.swift
//  Anchor
//
//  Created by Morris Richman on 2/3/25.
//

import Foundation
import SwiftUI

extension Color {
    /// A function that dynamically updates the color based on `userInterfaceStyle`
    static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
        let uiColor = UIColor { $0.userInterfaceStyle == .light ? light : dark }
        
        return Color(uiColor: uiColor)
    }
    
    /// A function that dynamically updates the color based on `userInterfaceStyle`
    static func dynamicColor(light: Color, dark: Color) -> Color {
        dynamicColor(light: UIColor(light), dark: UIColor(dark))
    }
    
    // MARK: Custom Colors
    // Because Swift Playgrounds doesn't support ColorSets
    
    static var migraineTint: Self {
        dynamicColor(light: #colorLiteral(red: 0, green: 0.6205425858, blue: 0.3912295103, alpha: 1), dark: #colorLiteral(red: 0.178935051, green: 0.8115785718, blue: 0, alpha: 1))
    }
    
    static var homeCircleGradientColor1: Self {
        dynamicColor(light: #colorLiteral(red: 0.9488822818, green: 0.9043547511, blue: 0.7965047956, alpha: 1), dark: #colorLiteral(red: 0.7647058824, green: 0.7333333333, blue: 0.662745098, alpha: 1))
    }
    
    static var homeCircleGradientColor2: Self {
        dynamicColor(light: #colorLiteral(red: 0.9654352069, green: 0.7606447935, blue: 0.756244719, alpha: 1), dark: #colorLiteral(red: 0.7254901961, green: 0.6, blue: 0.6, alpha: 1))
    }
    
    static var homeCircleGradientColor3: Self {
        dynamicColor(light: #colorLiteral(red: 0.8365617394, green: 0.6227167249, blue: 0.7561656237, alpha: 1), dark: #colorLiteral(red: 0.6709461808, green: 0.5728670955, blue: 0.7410820127, alpha: 1))
    }
    
    static var homeCircleGradientColor4: Self {
        dynamicColor(light: #colorLiteral(red: 0.6709461808, green: 0.5728670955, blue: 0.7410820127, alpha: 1), dark: #colorLiteral(red: 0.5098039216, green: 0.4549019608, blue: 0.5803921569, alpha: 1))
    }
    
    static var homeAntiCircleGradientColor1: Self {
        dynamicColor(light: #colorLiteral(red: 0.7559938431, green: 0.8822496533, blue: 0.9571807981, alpha: 1), dark: #colorLiteral(red: 0.5657837391, green: 0.6617270112, blue: 0.7242951989, alpha: 1))
    }
    
    static var homeAntiCircleGradientColor2: Self {
        dynamicColor(light: #colorLiteral(red: 0.7289828658, green: 0.8144184947, blue: 0.9409591556, alpha: 1), dark: #colorLiteral(red: 0.5455492139, green: 0.605802834, blue: 0.7113747001, alpha: 1))
    }
}
