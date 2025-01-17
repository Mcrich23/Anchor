//
//  PanicAttackStepsView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI

enum PanicAttackSteps: Int, CaseIterable {
    case assurance, takeAction
    
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
    @State var stepManager = PAStepManager()
    
    var body: some View {
        VStack {
            switch stepManager.step {
            case .assurance:
                PAAssuranceView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            case .takeAction:
                PATakeActionView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
//            case .alertSomeone:
//                PATakeMedicationView()
//                    .fillSpaceAvailable()
//                    .backForward(isBack: stepManager.isBack)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                if stepManager.step.rawValue != PanicAttackSteps.allCases.first?.rawValue {
                    Button("Back", systemImage: "chevron.left") {
                        withAnimation {
                            stepManager.previous()
                        }
                    }
                    .buttonStyle(.bordered)
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
        .padding()
        .environment(stepManager)
    }
}

#Preview {
    PanicAttackStepsView()
}
