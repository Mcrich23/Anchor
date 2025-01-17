//
//  PanicAttackStepsView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI

enum PanicAttackSteps: Int, CaseIterable {
    case assurance, takeMedication, alertSomeone
    
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
            case .takeMedication:
                PATakeMedicationView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
            case .alertSomeone:
                PATakeMedicationView()
                    .fillSpaceAvailable()
                    .backForward(isBack: stepManager.isBack)
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
                }
                Spacer()
                if stepManager.step.rawValue != PanicAttackSteps.allCases.last?.rawValue {
                    Button("Next", systemImage: "chevron.right") {
                        withAnimation {
                            stepManager.next()
                        }
                    }
                    .labelStyle(.oppositeOrderLabelStyle)
                }
            }
            .padding()
        }
        .padding()
        .environment(stepManager)
    }
}

private struct PAAssuranceView: View {
    var body: some View {
        VStack {
            Text("Its alright to be in pain. It cannot physically hurt you, and it will go away.")
        }
    }
}

private struct PATakeMedicationView: View {
    var body: some View {
        VStack {
            Text("Take your medication.")
        }
    }
}

#Preview {
    PanicAttackStepsView()
}
