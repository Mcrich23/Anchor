//
//  PanicAttackStepsView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI
import CoreHaptics

enum MigraineSteps: Int, ViewSteps {
    case takeAction, breath, drawing
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
    @Environment(MStepManager.self) var stepManager
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom
    @Environment(\.navigationNamespace) var navigationNamespace
    
    var body: some View {
        GeometryReader { geo in
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
                            .buttonStyle(.reliefNavigation)
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
                            .buttonStyle(.reliefNavigation)
                        }
                    }
                    .padding()
                }
            }
            .sensoryFeedback(.success, trigger: stepManager.step)
            .environment(\.geometrySize, geo.size)
        }
    }
}

#Preview {
    PanicAttackStepsView()
}
