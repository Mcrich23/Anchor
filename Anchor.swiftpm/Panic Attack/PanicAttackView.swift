//
//  PanicAttackIntroductionView.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import SwiftUI

struct PanicAttackView: View {
    @Environment(\.customDismiss) var dismiss
    @State var isStartScreen = true
    @State var stepManager = PAStepManager()
    @Namespace var navigationNamespace
    
    var body: some View {
        VStack {
            PanicAttackSplashView(isStartScreen: $isStartScreen)
                .padding(.horizontal, 10)
            if !isStartScreen {
                PanicAttackStepsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing, content: {
            if isStartScreen {
                AudioPlayerButtonView()
                    .matchedGeometryEffect(id: "audioPlayerButton", in: navigationNamespace)
                    .padding(.trailing)
            }
        })
        .environment(\.navigationNamespace, navigationNamespace)
        .environment(stepManager)
    }
}

#Preview {
    PanicAttackView()
}
