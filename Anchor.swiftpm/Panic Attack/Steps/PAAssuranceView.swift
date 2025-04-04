//
//  PAAssuranceView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI
import AVFoundation

private enum PAAssuranceStep: Int, CaseIterable {
    case intro
    case recording
    case conclusion
    
    mutating func next() {
        self = PAAssuranceStep(rawValue: self.rawValue+1) ?? self
    }
    
    mutating func previous() {
        self = PAAssuranceStep(rawValue: self.rawValue-1) ?? self
    }
}

struct PAAssuranceView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(PAStepManager.self) var stepManager
    @State private var step: PAAssuranceStep = .intro
    @Environment(\.geometrySize) var geo
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom
    @EnvironmentObject var userResponseController: UserResponseController
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    let mantra = "I am experiencing a panic attack. It is okay to feel this way. I don't need to escape it, just work with it."
    
    var height: CGFloat {
        min(geo.width, geo.height)
    }
    
    var numberOfTimesMantraSaid: Int {
        do {
            // Adjust regex for more flexibility with optional parts and variations
            let mantraRegex = try Regex(#"(?i)(I\s*am|I'm)\s+experiencing\s+(a\s+)?panic\s+attack\s+(It\s+is|It's)\s+(okay|ok)\s+(to\s+feel|that\s+I\s+feel|I\s+feel)\s+this\s+way\s+(I\s+do\s+not|I\s+don't|I\s+dont)\s+need\s+to\s+escape\s+it\s+just\s+work\s+with\s+it"#)
            let transcript = speechRecognizer.transcript.replacingOccurrences(of: "\\", with: "").trimmingCharacters(in: .punctuationCharacters).lowercased()
            
            // Get count of matches
            let count = transcript.ranges(of: mantraRegex).count
            
            // Return count that is >= 0
            return max(count, 0)
        } catch {
            print("Regex error:", error)
            return 0
        }
    }
    
    var animatedMeshView: some View {
        AnimatedMeshView(colors: [
            .red, .purple, .purple,
            .purple, .orange, .purple,
            .yellow, .purple, .purple
        ])
        .scaleEffect(1.2)
        .opacity(0.7)
    }
    
    var body: some View {
        ZStack {
            animatedMeshView
            Group {
                switch step {
                case .intro:
                    introView
                case .recording:
                    mantraView
                case .conclusion:
                    conclusionView
                }
            }
            .sensoryFeedback(.success, trigger: step)
            .foregroundStyle(colorScheme == .light ? .white: .black)
            .frame(maxWidth: height*0.55, maxHeight: height*0.65)
            .padding(.bottom, -20)
            .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: height*0.8, maxHeight: height*0.8)
        .clipShape(.circle)
        .background {
            animatedMeshView
                .frame(maxWidth: height*0.8, maxHeight: height*0.8)
                .opacity(0.7)
                .blur(radius: 15, opaque: true)
                .clipShape(.circle)
                .scaleEffect(1 + speechRecognizer.inputNoiseLevel)
        }
        .animation(.default, value: speechRecognizer.inputNoiseLevel)
        .padding()
        .padding(.bottom, userInterfaceIdiom == .phone ? 70 : 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            if isRecording && userInterfaceIdiom == .phone {
                ViewThatFits {
                    VStack(spacing: 15) {
                        mantraViewButtons(collapsed: false)
                    }
                    HStack(alignment: .center, spacing: 15) {
                        mantraViewButtons(collapsed: true)
                    }
                }
                .padding(.bottom, userInterfaceIdiom == .phone ? 20 : 0)
            }
        }
    }
    
    @ViewBuilder
    var introView: some View {
        VStack(spacing: 40) {
            Text("Acknowledgement")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
                .lineLimit(1)
            Text("Before we continue, we need to acknowledge your anxiety.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .light ? .white: .black)
                .minimumScaleFactor(0.6)
            Button {
                withAnimation {
                    startTranscription()
                    step.next()
                }
            } label: {
                Label("Get Started", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 200, alignment: .center)
            }
            .buttonStyle(.reactiveBorderedProminent)
        }
    }
    
    func checkmarkAccessibilityLabel(for i: Int) -> String {
        guard numberOfTimesMantraSaid >= i else {
            return "Checkmark \(i) incomplete, repeat the mantra to complete"
        }
        
        return "Checkmark \(i) complete"
    }
    
    @ViewBuilder
    var mantraView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text("Say The Following Mantra:")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .light ? .white: .black)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                
                Text(mantra)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(colorScheme == .light ? .white: .black)
                    .lineSpacing(10)
                    .minimumScaleFactor(0.6)
            }
                .layoutPriority(1)
            
            HStack(spacing: 20) {
                ForEach(1..<4, id: \.self) { i in
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(numberOfTimesMantraSaid >= i ? Color.green : Color.secondary)
                        .frame(minHeight: 15, maxHeight: 40)
                        .accessibilityLabel(Text("Checkmark \(i) incomplete, repeat the mantra to complete"))
                }
            }
            
            if isRecording && userInterfaceIdiom != .phone {
                ViewThatFits {
                    VStack(spacing: 15) {
                        mantraViewButtons(collapsed: false)
                    }
                    HStack(alignment: .center, spacing: 15) {
                        mantraViewButtons(collapsed: true)
                    }
                }
            }
        }
        .padding(.vertical, geo.height == height ? -10 : 0)
//        .dynamicTypeSize(.medium)
        .onChange(of: numberOfTimesMantraSaid) {
            guard numberOfTimesMantraSaid >= 3 else { return }
            Task {
                try? await Task.sleep(for: .seconds(1))
                await self.userResponseController.playSoundEffect(.complete)
                withAnimation {
                    step.next()
                    endTranscription()
                }
            }
        }
    }
    
    @ViewBuilder
    func mantraViewButtons(collapsed: Bool) -> some View {
        Label("Listening...", systemImage: "microphone.fill")
            .labelStyle(.titleAndIcon)
            .foregroundStyle(Color.primary)
            .colorInvert()
            .padding()
            .frame(maxWidth: collapsed ? 175 : 200, maxHeight: 50, alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.tint)
            }
        
        Button {
            self.userResponseController.playSoundEffect(.complete)
            withAnimation {
                step.next()
            } completion: {
                endTranscription()
            }
        } label: {
            Group {
                switch collapsed {
                case true:
                    Label("Skip", systemImage: "chevron.forward")
                        .labelStyle(.iconOnly)
                case false:
                    Label("Skip", systemImage: "chevron.forward")
                        .labelStyle(.titleOnly)
                }
            }
                .foregroundStyle(.tint)
                .font(.body)
                .fixedSize()
                .padding()
                .frame(maxWidth: collapsed ? 50 : 200, maxHeight: 50, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
                .minimumScaleFactor(0.5)
        }
        .buttonStyle(.reactive)
    }
    
    @ViewBuilder
    var conclusionView: some View {
        VStack(spacing: 30) {
            Text("Good Job!")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Lets move on to grounding techniques.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Button {
                stepManager.next()
            } label: {
                Label("Continue", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 200, alignment: .center)
            }
            .buttonStyle(.reactiveBorderedProminent)
        }
    }
    
    private func startTranscription() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func endTranscription() {
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
}

extension StringProtocol {
    func numberOfOccurrences(of substring: String) -> Int {
        let array = split(separator: substring)
        let count = array.count - 1
        return Swift.max(count, 0) // Ensure non-negative count
    }

    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...].range(of: string, options: options) {
            result.append(range)
            startIndex = range.upperBound // Move to the end of the current match
        }
        return result
    }
}
