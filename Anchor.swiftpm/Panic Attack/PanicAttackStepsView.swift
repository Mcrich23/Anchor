//
//  PanicAttackStepsView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI
import CoreHaptics

enum PanicAttackSteps: Int, CaseIterable {
    case assurance, breath, drawing
    
    mutating func next() {
        guard let next = Self(rawValue: self.rawValue+1) else { return }
        self = next
    }
    mutating func previous() {
        guard let next = Self(rawValue: self.rawValue-1) else { return }
        self = next
    }
}

extension EnvironmentValues {
    @Entry var geometrySize: CGSize = .zero
    @Entry var navigationNamespace: Namespace.ID?
}

@Observable
final class PAStepManager {
    private(set) var step: PanicAttackSteps = .assurance
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

struct PanicAttackStepsView: View {
    @State var geometrySize: CGSize = .zero
    @Environment(PAStepManager.self) var stepManager
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom
    @Environment(\.navigationNamespace) var navigationNamespace
    
    var body: some View {
        VStack {
            switch stepManager.step {
            case .assurance:
                PAAssuranceView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            case .breath:
                PABreathingView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            case .drawing:
                PADrawingView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if stepManager.step != .drawing || userInterfaceIdiom != .phone {
                HStack {
                    if stepManager.step.rawValue != PanicAttackSteps.allCases.first?.rawValue {
                        Button("Back", systemImage: "chevron.left") {
                            withAnimation {
                                stepManager.previous()
                            }
                        }
                        .buttonStyle(.bordered)
                        .matchedGeometryEffect(id: "backButton", in: navigationNamespace)
                    }
                    Spacer()
                    if stepManager.step.rawValue != PanicAttackSteps.allCases.last?.rawValue && stepManager.step.rawValue != PanicAttackSteps.allCases.first?.rawValue {
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
