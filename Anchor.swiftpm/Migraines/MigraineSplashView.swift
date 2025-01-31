//
//  PanicAttackSplashView.swift
//  Anchor
//
//  Created by Morris Richman on 1/15/25.
//

import SwiftUI

struct MigraineSplashView: View {
    @Environment(\.customDismiss) var dismiss
    @Binding var isStartScreen: Bool
    @Namespace var namespace
    @Environment(MStepManager.self) var stepManager
    @Environment(\.navigationNamespace) var navigationNamespace
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom
    
    var body: some View {
        Group {
            if isStartScreen {
                VStack {
                    Text("Migraine Relief")
                        .font(.title)
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .bold()
                    Text("A migraine can be very scary. Anchor is hear to help you through it.")
                        .multilineTextAlignment(.center)
                    HStack {
                        Button("Back", action: dismiss)
                            .buttonStyle(.bordered)
                            .matchedGeometryEffect(id: "close", in: namespace)
                        if isStartScreen {
                            Button("Start Relief") {
                                withAnimation(.easeInOut(duration: 1.2)) {
                                    isStartScreen.toggle()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .matchedGeometryEffect(id: "container", in: namespace)
            } else {
                VStack {
                    HStack {
                        Text("Migraine Relief")
                            .font(.title)
                            .matchedGeometryEffect(id: "title", in: namespace)
                            .bold()
                            .fontDesign(.default)
                        if !(navigationNamespace != nil && userInterfaceIdiom == .phone && stepManager.step == .drawing) {
                            Spacer()
                            Button("Close", action: dismiss)
                                .buttonStyle(.bordered)
                                .matchedGeometryEffect(id: "close", in: namespace)
                        }
                    }
                    if let navigationNamespace, userInterfaceIdiom == .phone, stepManager.step == .drawing {
                        HStack {
                            Button("Back", systemImage: "chevron.left") {
                                withAnimation {
                                    stepManager.previous()
                                }
                            }
                            .buttonStyle(.bordered)
                            .matchedGeometryEffect(id: "backButton", in: navigationNamespace)
                            Spacer()
                            Button("Close", action: dismiss)
                                .buttonStyle(.bordered)
                                .matchedGeometryEffect(id: "close", in: namespace)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color(uiColor: .secondarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .matchedGeometryEffect(id: "container", in: namespace)
            }
        }
        .padding()
    }
}
