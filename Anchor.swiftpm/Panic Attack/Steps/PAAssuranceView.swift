//
//  PAAssuranceView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

private enum PAAssuranceStep: Int, CaseIterable {
    case intro
    case recording
    case conclusion
    
    mutating func next() {
        self = PAAssuranceStep(rawValue: self.rawValue+1) ?? self
    }
    
    mutating func previous() {
        self = PAAssuranceStep(rawValue: self.rawValue-1) ?? self
    }
}

struct PAAssuranceView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PAStepManager.self) var stepManager
    @State private var step: PAAssuranceStep = .intro
    @Environment(\.geometrySize) var geo
    
    var body: some View {
        ZStack {
            AnimatedMeshView(colors: [
                .red, .purple, .purple,
                .purple, .orange, .purple,
                .yellow, .purple, .purple
            ])
            .scaleEffect(1.2)
            Group {
                switch step {
                case .intro:
                    introView
                case .recording:
                    mantraView
                case .conclusion:
                    conclusionView
                }
            }
            .padding(.horizontal, 40)
            .padding()
        }
        .frame(width: geo.height*0.8, height: geo.height*0.8)
        .clipShape(.circle)
    }
    
    @ViewBuilder
    var introView: some View {
        VStack(spacing: 40) {
            Text("Acknowledgement")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Text("Before we continue, we need to create acknowledge your anxiety.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Button {
                withAnimation {
                    step.next()
                }
            } label: {
                Label("Get Started", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 700, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    var mantraView: some View {
        VStack(spacing: 60) {
            Text("Repeat The Following Mantra:")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            
            Text("I am experiencing a panic attack. It is okay to feel this way. I don't need to escape it, just work with it.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
                .lineSpacing(10)
        }
    }
    
    @ViewBuilder
    var conclusionView: some View {
        VStack(spacing: 40) {
            Text("Good Job!")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Text("Lets move on to grounding techniques.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Button(action: stepManager.next) {
                Label("Continue", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 700, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
