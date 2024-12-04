//
//  FloatingButtonStyle.swift
//  Anchor
//
//  Created by Morris Richman on 12/3/24.
//

import SwiftUI

struct FloatingButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.clear)
                    .background(.thickMaterial)
//                    .shadow(color: .primary, radius: 2, y: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

extension PrimitiveButtonStyle where Self == FloatingButtonStyle {
    static var floating: FloatingButtonStyle { get { .init() } set{} }
}
