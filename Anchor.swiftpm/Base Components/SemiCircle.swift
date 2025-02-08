//
//  SemiCircle.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import SwiftUI

struct SemiCircle: View {
    let colors: [Color]
    @State var size: CGSize?
    @ObservedObject var animatedMeshViewModel: AnimatedMeshViewModel
    
    init(colors: [Color], size: CGSize? = nil, animatedMeshViewModel: AnimatedMeshViewModel = .init()) {
        self.colors = colors
        self.size = size
        self.animatedMeshViewModel = animatedMeshViewModel
    }
    
    var body: some View {
            Rectangle()
            .fill(Color.clear)
                .overlay(alignment: .top, content: {
                    if let size {
                        AnimatedMeshView(colors: colors, speed: 0.02, viewModel: animatedMeshViewModel)
                            .clipShape(
                                Ellipse()
                                    .trim(from: 0.5, to: 1)
                                    .size(width: size.width, height: size.height*2)
                            )
                    }
                })
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                size = newValue
            }

    }
}
