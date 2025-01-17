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
    @Environment(\.geometrySize) var geo
    
    var scaleEffect: CGFloat {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return geo.width/1344.0 }
        
        return geo.width/600
    }
    
    var body: some View {
        VStack(spacing: 50) {
            VStack {
                Text("Let's Take Some Deep Breaths")
                    .font(.largeTitle)
                    .bold()
                Text("Taking deep breaths can slow your heart rate, alieviating anxiety and stress.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .minimumScaleFactor(0.8)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            ZStack {
                Circle()
                    .fill(.clear)
                    .frame(width: geo.width*0.6, height: geo.height*0.6)
                    .background {
                        Circle()
                            .fill(Color.purple)
                            .opacity(0.6)
                            .frame(width: geo.width/5.9733333333, height: geo.width/5.9733333333)
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
                            .frame(width: geo.width/8.96, height: geo.width/8.96)
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
//            .padding(geo.width/8.96)
//            .scaleEffect(scaleEffect)
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
            .frame(width: geo.width/22.4, height: geo.width/19.2)
            .padding(.top, -geo.width/19.2)
            .opacity(0.8)
    }
    
    @ViewBuilder
    var outerPedal: some View {
        Ellipse()
            .fill(.indigo)
            .frame(width: geo.width/10.3384615385, height: geo.width/8.96)
            .padding(.top, -geo.width/6.72)
            .opacity(0.8)
    }
}

#Preview {
    PABreathingView()
}
