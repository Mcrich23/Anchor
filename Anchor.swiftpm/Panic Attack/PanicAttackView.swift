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
    
    var body: some View {
        VStack {
            PanicAttackSplashView(isStartScreen: $isStartScreen)
            if !isStartScreen {
                PanicAttackStepsView()
            }
        }
        .padding()
    }
}

#Preview {
    PanicAttackView()
}
