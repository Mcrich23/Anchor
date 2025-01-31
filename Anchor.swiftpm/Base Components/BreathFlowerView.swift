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
    @State private var isFlowerExpanded: Bool = false
    @State private var breathState: BreathState?
    @State private var isBreathing: Bool = false
    @State private var countdown: Int = 4
    
    @Environment(\.geometrySize) private var geo
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
    @State private var hapticEngine: CHHapticEngine?
    let stepDuration = 4.0 // Keep at whole seconds
    
    var scaleModifier: CGFloat {
        let orientation = self.orientation.isFlat ? self.previousOrientation : self.orientation
        
        switch orientation.isPortrait {
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
                        .fill(Color.purple)
                        .opacity(0.6)
                        .frame(width: scaleModifier/5.9733333333, height: scaleModifier/5.9733333333)
                }
            //                .background {
            //                    ZStack {
            //                        innerPedal
            //                            .rotationEffect(Angle(degrees: 45))
            //                        innerPedal
            //                            .rotationEffect(Angle(degrees: 135))
            //                        innerPedal
            //                            .rotationEffect(Angle(degrees: 225))
            //                        innerPedal
            //                            .rotationEffect(Angle(degrees: 315))
            //                    }
            //                }
                .background {
                    Circle()
                        .fill(.mint)
                        .frame(width: scaleModifier/8.96, height: scaleModifier/8.96)
                        .opacity(0.9)
                        .blur(radius: 50)
                }
                .background {
                    ZStack {
                        outerPedal
                        outerPedal
                            .rotationEffect(Angle(degrees: 40))
                        outerPedal
                            .rotationEffect(Angle(degrees: 80))
                        outerPedal
                            .rotationEffect(Angle(degrees: 120))
                        outerPedal
                            .rotationEffect(Angle(degrees: 160))
                        outerPedal
                            .rotationEffect(Angle(degrees: 200))
                        outerPedal
                            .rotationEffect(Angle(degrees: 240))
                        outerPedal
                            .rotationEffect(Angle(degrees: 280))
                        outerPedal
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
        .onRotate { orientation in
            self.previousOrientation = self.orientation
            self.orientation = orientation
        }
        .onAppear {
            prepareHaptics()
        }
    }
    
    @ViewBuilder
    var innerPedal: some View {
        Ellipse()
            .fill(.mint)
            .frame(width: scaleModifier/22.4, height: scaleModifier/19.2)
            .padding(.top, -scaleModifier/19.2)
            .opacity(0.8)
    }
    
    @ViewBuilder
    var outerPedal: some View {
        Ellipse()
            .fill(.indigo)
            .frame(width: scaleModifier/10.3384615385, height: scaleModifier/8.96)
            .padding(.top, -scaleModifier/6.72)
            .opacity(0.8)
    }
    
    func runBreath() {
        Task {
            withAnimation {
                isBreathing = true
            }
            for i in 0..<4 {
                await breath(holdAtEnd: i < 3)
            }
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
        countdown(from: Int(stepDuration.rounded(.up)))
        try? await Task.sleep(for: .seconds(stepDuration))
        withAnimation {
            self.countdown = Int(stepDuration.rounded(.up))
            breathState = .breathOut
        }
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
