//
//  BreathFlowerView.swift
//  Anchor
//
//  Created by Morris Richman on 1/30/25.
//

import SwiftUI
import CoreHaptics

enum BreathState: String, CaseIterable {
    case breathIn = "Breathe In"
    case hold = "Hold"
    case breathOut = "Breathe Out"
}

struct BreathFlowerView: View {
    let pistilColor: Color
    let petalColor: Color
    let isVisible: Bool
    
    init(pistilColor: Color = .purple, petalColor: Color = .indigo, isVisible: Bool) {
        self.pistilColor = pistilColor
        self.petalColor = petalColor
        self.isVisible = isVisible
    }
    
    @State private var isFlowerExpanded: Bool = false
    @State private var breathState: BreathState?
    @State private var isBreathing: Bool = false
    @State private var countdown: Int = 4
    @State private var breathTask: Task<Void, Error>?
    
    @Environment(\.geometrySize) private var geo
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.nonFlatOrientation) private var nonFlatOrientation
    @EnvironmentObject var userResponseController: UserResponseController
    @State private var hapticEngine: CHHapticEngine?
    let stepDuration = 4.0 // Keep at whole seconds
    
    var scaleModifier: CGFloat {
        switch nonFlatOrientation.isPortrait {
        case true:
            return geo.height*1.3
        case false:
            return geo.width
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.clear)
                .frame(maxWidth: .infinity)
                .frame(height: geo.height*0.6)
                .background {
                    Circle()
                        .fill(pistilColor)
                        .opacity(colorScheme == .light ? 0.6 : 0.3)
                        .frame(width: scaleModifier/5.9733333333, height: scaleModifier/5.9733333333)
                }
                .background {
                    Circle()
                        .fill(.mint)
                        .frame(width: scaleModifier/8.96, height: scaleModifier/8.96)
                        .opacity(colorScheme == .light ? 0.9 : 0.6)
                        .blur(radius: 50)
                }
                .background {
                    ZStack {
                        outerPetal
                        outerPetal
                            .rotationEffect(Angle(degrees: 40))
                        outerPetal
                            .rotationEffect(Angle(degrees: 80))
                        outerPetal
                            .rotationEffect(Angle(degrees: 120))
                        outerPetal
                            .rotationEffect(Angle(degrees: 160))
                        outerPetal
                            .rotationEffect(Angle(degrees: 200))
                        outerPetal
                            .rotationEffect(Angle(degrees: 240))
                        outerPetal
                            .rotationEffect(Angle(degrees: 280))
                        outerPetal
                            .rotationEffect(Angle(degrees: 320))
                    }

                }
                .scaleEffect(isFlowerExpanded ? 1.5 : 1)
                .rotationEffect(Angle(degrees: isFlowerExpanded ? 48 : 0))
            if !isBreathing {
                Button(action: runBreath) {
                    Text("Start")
                        .padding()
                }
                .font(.title)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .buttonStyle(.secondaryReactive)
            } else if let breathState {
                VStack {
                    Text(breathState.rawValue)
                    Text(countdown.description)
                        .contentTransition(.numericText(countsDown: true))
                }
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .transition(.opacity)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            prepareHaptics()
        }
        .onChange(of: isVisible) { _, newValue in
            guard !newValue else { return }
            breathTask?.cancel()
        }
    }
    
    @ViewBuilder
    var outerPetal: some View {
        Ellipse()
            .fill(petalColor)
            .frame(width: scaleModifier/10.3384615385, height: scaleModifier/8.96)
            .padding(.top, -scaleModifier/6.72)
            .opacity(0.8)
    }
    
    func runBreath() {
        self.breathTask?.cancel()
        self.breathTask = Task {
            withAnimation {
                isBreathing = true
            }
            for i in 0..<4 {
                await breath(holdAtEnd: i < 3)
            }
            await userResponseController.playSoundEffect(.complete)
            withAnimation {
                isBreathing = false
            }
        }
    }
    
    private func playHaptics(_ events: [CHHapticEvent]) {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    private func countdown(from: Int) {
        Task {
            // Reset Countdown
            withAnimation {
                self.countdown = from
            }
            // Add Haptics
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let events: [CHHapticEvent] = [
                CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            ]
            playHaptics(events)
            
            // Run Countdown
            for _ in 1..<from {
                try? await Task.sleep(for: .seconds(1))
                withAnimation {
                    self.countdown -= 1
                }
            }
        }
    }
    
    func breath(holdAtEnd: Bool = true) async {
        withAnimation {
            self.countdown = Int(stepDuration.rounded(.up))
            breathState = .breathIn
        }
        await userResponseController.playSoundEffect(.primaryClick)
        countdown(from: Int(stepDuration.rounded(.up)))
        await withCheckedContinuation { continuation in
            withAnimation(.easeInOut(duration: stepDuration)) {
                isFlowerExpanded = true
            } completion: {
                continuation.resume()
            }
        }
        withAnimation {
            self.countdown = Int(stepDuration.rounded(.up))
            breathState = .hold
        }
        await userResponseController.playSoundEffect(.secondaryClick)
        countdown(from: Int(stepDuration.rounded(.up)))
        try? await Task.sleep(for: .seconds(stepDuration))
        withAnimation {
            self.countdown = Int(stepDuration.rounded(.up))
            breathState = .breathOut
        }
        await userResponseController.playSoundEffect(.primaryClick)
        countdown(from: Int(stepDuration.rounded(.up)))
        await withCheckedContinuation { continuation in
            withAnimation(.easeInOut(duration: stepDuration)) {
                isFlowerExpanded = false
            } completion: {
                continuation.resume()
            }
        }
        if holdAtEnd {
            withAnimation {
                self.countdown = Int(stepDuration.rounded(.up))
                breathState = .hold
            }
            await userResponseController.playSoundEffect(.secondaryClick)
            countdown(from: Int(stepDuration.rounded(.up)))
            try? await Task.sleep(for: .seconds(stepDuration))
        }
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}

#Preview {
    @Previewable @State var stepManager = MStepManager()
    
    GeometryReader { geo in
        MBreathingView()
            .environment(\.geometrySize, geo.size)
            .environment(stepManager)
    }
}
