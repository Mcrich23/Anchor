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
    @State var isShowingNavigationBar = true
    
    var body: some View {
        VStack {
            if isShowingNavigationBar {
                if !isStartScreen {
                    MigraineSplashView(isStartScreen: $isStartScreen)
                        .padding(.horizontal, 10)
                } else if isStepsLoaded {
                    MigraineSplashView(isStartScreen: .constant(false))
                        .opacity(0)
                        .environment(\.navigationNamespace, nil)
                }
            }
            
            if isStepsLoaded || !isStartScreen {
                MigraineStepsView(isStartScreen: isStartScreen)
                    .opacity(isStartScreen ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            try? await Task.sleep(for: .milliseconds(600))
            isStepsLoaded = true
        }
        .overlay {
            if isStartScreen {
                MigraineSplashView(isStartScreen: $isStartScreen)
            }
        }
        .overlay(alignment: .bottomTrailing, content: {
            if isStartScreen {
                AudioPlayerButtonView()
                    .matchedGeometryEffect(id: "audioPlayerButton", in: navigationNamespace)
                    .padding(.trailing)
            }
        })
        .environment(\.navigationNamespace, navigationNamespace)
        .environment(\.isShowingNavigationBar, $isShowingNavigationBar)
        .environment(stepManager)
    }
}

#Preview {
    MigraineView()
}
