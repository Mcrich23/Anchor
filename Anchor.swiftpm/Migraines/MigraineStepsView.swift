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

extension EnvironmentValues {
    @Entry var isShowingNavigationButtons: Binding<Bool> = .constant(false)
    @Entry var isShowingNavigationBar: Binding<Bool> = .constant(false)
}

struct MigraineStepsView: View {
    let isStartScreen: Bool
    @Environment(MStepManager.self) var stepManager
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom
    @Environment(\.navigationNamespace) var navigationNamespace
    @State var isShowingNavigationButtons = false
    
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
                if !isStartScreen && isShowingNavigationButtons {
                    HStack {
                        if (stepManager.step != .drawing || userInterfaceIdiom != .phone) && stepManager.step.rawValue != MigraineSteps.allCases.first?.rawValue {
                            Button("Back", systemImage: "chevron.left") {
                                withAnimation {
                                    stepManager.previous()
                                }
                            }
                            .buttonStyle(.reliefBackNavigation)
                            .matchedGeometryEffect(id: "backButton", in: navigationNamespace)
                        }
                        Spacer()
                        AudioPlayerButtonView()
                            .matchedGeometryEffect(id: "audioPlayerButton", in: navigationNamespace)
                        if (stepManager.step != .drawing || userInterfaceIdiom != .phone) && stepManager.step.rawValue != MigraineSteps.allCases.last?.rawValue {
                            Button("Next", systemImage: "chevron.right") {
                                withAnimation {
                                    stepManager.next()
                                }
                            }
                            .labelStyle(.oppositeOrderLabelStyle)
                            .buttonStyle(.reliefNavigation)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .sensoryFeedback(.success, trigger: stepManager.step)
            .environment(\.geometrySize, geo.size)
            .environment(\.isShowingNavigationButtons, $isShowingNavigationButtons)
        }
    }
}

#Preview {
    PanicAttackStepsView()
}
