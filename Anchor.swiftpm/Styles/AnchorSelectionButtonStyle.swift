//
//  AnchorSelectionButtonStyle.swift
//  Anchor
//
//  Created by Morris Richman on 2/10/25.
//

import SwiftUI

struct AnchorSelectionButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var material: Material {
        switch colorScheme {
        case .dark: .ultraThinMaterial
        default: .regularMaterial
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 150)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.clear)
                    .shadow(color: .primary, radius: 3, y: 1)
            }
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
