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


//
private struct PAAssuranceView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PAStepManager.self) var stepManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedMeshView()
                    .scaleEffect(1.2)
                VStack(spacing: 50) {
                    Text("Its alright to be in pain.\n\nIt cannot physically hurt you, and it will go away.")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .bold()
                        .foregroundStyle(colorScheme == .light ? .white: .black)
                    Button(action: stepManager.next) {
                        Label("Next", systemImage: "chevron.right")
                            .labelStyle(.titleOnly)
                            .frame(maxWidth: geo.size.width/3, alignment: .center)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .clipShape(.circle)
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
