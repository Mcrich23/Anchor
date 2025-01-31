//
//  PABreathingView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI

struct MBreathingView: View {
    var body: some View {
        VStack(spacing: 50) {
            VStack {
                Text("Let's Take Some Deep Breaths")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Taking deep breaths can slow your heart rate, alieviating anxiety and stress.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .minimumScaleFactor(0.8)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            BreathFlowerView(pistilColor: .init(.migraineTint))
//            .padding(scaleModifier/8.96)
//            .scaleEffect(scaleEffect)
        }
    }
}

#Preview {
    MBreathingView()
}
