//
//  SemiCircle.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import SwiftUI

struct SemiCircle: View {
    @State var size: CGSize?
    
    var body: some View {
            Rectangle()
            .fill(Color.clear)
                .overlay(alignment: .top, content: {
                    if let size {
                        Ellipse()
                            .trim(from: 0.5, to: 1)
                            .size(width: size.width, height: size.height*2)
                            .fill(.primary)
                    }
                })
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                size = newValue
            }

    }
}
