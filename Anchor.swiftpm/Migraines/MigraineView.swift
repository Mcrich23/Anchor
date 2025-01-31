//
//  MigraineView.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import SwiftUI

struct MigraineView: View {
    @Environment(\.customDismiss) var dismiss
    @State var isStartScreen = true
    @State var stepManager = MStepManager()
    @Namespace var navigationNamespace
    
    var body: some View {
        VStack {
            MigraineSplashView(isStartScreen: $isStartScreen)
                .padding(.horizontal)
            if !isStartScreen {
                MigraineStepsView()
            }
        }
        .padding()
        .environment(\.navigationNamespace, navigationNamespace)
        .environment(stepManager)
    }
}

#Preview {
    MigraineView()
}
