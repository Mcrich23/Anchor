//
//  PABreathingView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI

private enum BreathState: String, CaseIterable {
    case breathIn = "Breathe In"
    case hold = "Hold"
    case breathOut = "Breathe Out"
}

struct PABreathingView: View {
    @State private var isFlowerExpanded: Bool = false
    @State private var breathState: BreathState?
    @State private var isBreathing: Bool = false
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Let's Take Some Deep Breaths")
                .font(.largeTitle)
                .bold()
            ZStack {
                Circle()
                    .fill(Color.purple)
                    .opacity(0.6)
                    .frame(width: 225, height: 225)
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
                            .frame(width: 150, height: 150)
                            .opacity(0.9)
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
                    .rotationEffect(Angle(degrees: isFlowerExpanded ? 115 : 0))
                if !isBreathing {
                    Button("Start", action: runBreath)
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                } else if let breathState {
                    Text(breathState.rawValue)
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                        .contentTransition(.opacity)
                        .transition(.opacity)
                }
            }
            .padding(150)
        }
    }
    
    func runBreath() {
        Task {
            isBreathing = true
            for _ in 0..<4 {
                await breath()
                try? await Task.sleep(for: .seconds(4))
            }
            isBreathing = false
        }
    }
    
    func breath() async {
        withAnimation {
            breathState = .breathIn
        }
        await withCheckedContinuation { continuation in
            withAnimation(.easeInOut(duration: 5)) {
                isFlowerExpanded = true
            } completion: {
                continuation.resume()
            }
        }
        withAnimation {
            breathState = .hold
        }
        try? await Task.sleep(for: .seconds(4))
        withAnimation {
            breathState = .breathOut
        }
        await withCheckedContinuation { continuation in
            withAnimation(.easeInOut(duration: 5)) {
                isFlowerExpanded = false
            } completion: {
                continuation.resume()
            }
        }
        withAnimation {
            breathState = .hold
        }
    }
    
    @ViewBuilder
    var innerPedal: some View {
        Ellipse()
            .fill(.mint)
            .frame(width: 60, height: 70)
            .padding(.top, -70)
            .opacity(0.8)
    }
    
    @ViewBuilder
    var outerPedal: some View {
        Ellipse()
            .fill(.indigo)
            .frame(width: 130, height: 150)
            .padding(.top, -200)
            .opacity(0.8)
    }
}

#Preview {
    PABreathingView()
}
