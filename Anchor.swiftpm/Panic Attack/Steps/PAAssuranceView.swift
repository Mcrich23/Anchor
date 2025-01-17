//
//  PAAssuranceView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

struct PAAssuranceView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PAStepManager.self) var stepManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedMeshView(colors: [
                    .red, .purple, .purple,
                    .purple, .orange, .purple,
                    .yellow, .purple, .purple
                ])
                    .scaleEffect(1.2)
                VStack(spacing: 40) {
                    Text("Its alright to be in pain.\n\nIt cannot physically hurt you, and it will go away.")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .bold()
                        .foregroundStyle(colorScheme == .light ? .white: .black)
                    Button(action: stepManager.next) {
                        Label("Next", systemImage: "chevron.right")
                            .labelStyle(.titleOnly)
                            .frame(maxWidth: geo.size.width/3, alignment: .center)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .clipShape(.circle)
        }
    }
}
