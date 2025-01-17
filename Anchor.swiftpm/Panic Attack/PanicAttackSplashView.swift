//
//  PanicAttackSplashView.swift
//  Anchor
//
//  Created by Morris Richman on 1/15/25.
//

import SwiftUI

struct PanicAttackSplashView: View {
    @Environment(\.customDismiss) var dismiss
    @Binding var isStartScreen: Bool
    @Namespace var namespace
    
    var body: some View {
        VStack {
            if isStartScreen {
                Text("Panic Attack Relief")
                    .font(.title)
                    .matchedGeometryEffect(id: "title", in: namespace)
                    .bold()
                Text("A panic attack can be very scary. Anchor is hear to help you through it.")
                    .multilineTextAlignment(.center)
                HStack {
                    Button("Back", action: dismiss)
                        .buttonStyle(.bordered)
                        .matchedGeometryEffect(id: "close", in: namespace)
                    if isStartScreen {
                        Button("Start Relief") {
                            withAnimation(.easeInOut(duration: 1.3)) {
                                isStartScreen.toggle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            } else {
                HStack {
                    Text("Panic Attack Relief")
                        .font(.title)
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .bold()
                        .fontDesign(.default)
                    Spacer()
                    Button("Close", action: dismiss)
                        .buttonStyle(.bordered)
                        .matchedGeometryEffect(id: "close", in: namespace)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color(uiColor: .secondarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
    }
}
