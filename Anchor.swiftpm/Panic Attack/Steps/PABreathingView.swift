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
    @State var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
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
        VStack(spacing: 50) {
            VStack {
                Text("Let's Take Some Deep Breaths")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Taking deep breaths can slow your heart rate, alieviating anxiety and stress.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .minimumScaleFactor(0.8)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
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
                    Text(breathState.rawValue)
                        .font(.title)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .contentTransition(.opacity)
                        .transition(.opacity)
                }
            }
//            .padding(scaleModifier/8.96)
//            .scaleEffect(scaleEffect)
        }
        .onRotate { orientation in
            self.previousOrientation = self.orientation
            self.orientation = orientation
        }
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
    
    func breath(holdAtEnd: Bool = true) async {
        withAnimation {
            breathState = .breathIn
        }
        await withCheckedContinuation { continuation in
            withAnimation(.easeInOut(duration: 4)) {
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
            withAnimation(.easeInOut(duration: 4)) {
                isFlowerExpanded = false
            } completion: {
                continuation.resume()
            }
        }
        if holdAtEnd {
            withAnimation {
                breathState = .hold
            }
            try? await Task.sleep(for: .seconds(4))
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
}

#Preview {
    PABreathingView()
}
