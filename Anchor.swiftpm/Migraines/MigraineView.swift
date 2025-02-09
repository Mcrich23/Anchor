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
    @State var isStepsLoaded = false
    
    var body: some View {
        VStack {
            if !isStartScreen {
                MigraineSplashView(isStartScreen: $isStartScreen)
                    .padding(.horizontal)
            } else if isStepsLoaded {
                MigraineSplashView(isStartScreen: .constant(false))
                    .padding(.horizontal)
                    .opacity(0)
                    .environment(\.navigationNamespace, nil)
            }
            if isStepsLoaded || !isStartScreen {
                MigraineStepsView()
                    .opacity(isStartScreen ? 0 : 1)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            try? await Task.sleep(for: .milliseconds(550))
            isStepsLoaded = true
        }
        .overlay {
            if isStartScreen {
                MigraineSplashView(isStartScreen: $isStartScreen)
                    .padding(.horizontal)
            }
        }
        .environment(\.navigationNamespace, navigationNamespace)
        .environment(stepManager)
    }
}

#Preview {
    MigraineView()
}
