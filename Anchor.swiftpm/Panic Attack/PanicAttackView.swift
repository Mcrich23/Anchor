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
                .padding(.horizontal)
            if !isStartScreen {
                PanicAttackStepsView()
            }
        }
        .padding()
        .environment(\.navigationNamespace, navigationNamespace)
        .environment(stepManager)
    }
}

#Preview {
    PanicAttackView()
}
