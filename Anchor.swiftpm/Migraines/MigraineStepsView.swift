//
//  PanicAttackStepsView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI
import CoreHaptics

enum MigraineSteps: Int, CaseIterable {
    case takeAction, breath, drawing
    
    mutating func next() {
        guard let next = Self(rawValue: self.rawValue+1) else { return }
        self = next
    }
    mutating func previous() {
        guard let next = Self(rawValue: self.rawValue-1) else { return }
        self = next
    }
}

@Observable
final class MStepManager {
    private(set) var step: MigraineSteps = .takeAction
    var isBack = false
    
    func next() {
        isBack = false
        withAnimation {
            step.next()
        }
    }
    func previous() {
        isBack = true
        withAnimation {
            step.previous()
        }
    }
}

struct MigraineStepsView: View {
    @State var geometrySize: CGSize = .zero
    @Environment(MStepManager.self) var stepManager
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom
    @Environment(\.navigationNamespace) var navigationNamespace
    
    var body: some View {
        VStack {
            switch stepManager.step {
            case .takeAction:
                MTakeActionView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            case .breath:
                MBreathingView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            case .drawing:
                MDrawingView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if stepManager.step != .drawing || userInterfaceIdiom != .phone {
                HStack {
                    if stepManager.step.rawValue != MigraineSteps.allCases.first?.rawValue {
                        Button("Back", systemImage: "chevron.left") {
                            withAnimation {
                                stepManager.previous()
                            }
                        }
                        .buttonStyle(.bordered)
                        .matchedGeometryEffect(id: "backButton", in: navigationNamespace)
                    }
                    Spacer()
                    if stepManager.step.rawValue != MigraineSteps.allCases.last?.rawValue {
                        Button("Next", systemImage: "chevron.right") {
                            withAnimation {
                                stepManager.next()
                            }
                        }
                        .labelStyle(.oppositeOrderLabelStyle)
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
        }
        .sensoryFeedback(.success, trigger: stepManager.step)
        .onGeometryChange(for: CGSize.self, of: { proxy in
            proxy.size
        }, action: { newValue in
            geometrySize = newValue
        })
        .environment(\.geometrySize, geometrySize)
    }
}

#Preview {
    PanicAttackStepsView()
}
