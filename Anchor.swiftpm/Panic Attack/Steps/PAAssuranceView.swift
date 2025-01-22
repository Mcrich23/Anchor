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
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    let mantra = "I am experiencing a panic attack. It is okay to feel this way. I don't need to escape it, just work with it."
    
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
            .foregroundStyle(colorScheme == .light ? .white: .black)
            .padding(.horizontal, 40)
            .padding()
        }
        .frame(width: geo.height*0.8, height: geo.height*0.8)
        .clipShape(.circle)
        .background {
            animatedMeshView
                .frame(width: geo.height*0.8, height: geo.height*0.8)
                .opacity(0.7)
                .blur(radius: 15, opaque: true)
                .clipShape(.circle)
            .scaleEffect(1 + speechRecognizer.inputNoiseLevel)
        }
        .animation(.default, value: speechRecognizer.inputNoiseLevel)
    }
    
    @ViewBuilder
    var introView: some View {
        VStack(spacing: 40) {
            Text("Acknowledgement")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Text("Before we continue, we need to create acknowledge your anxiety.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Button {
                startTranscription()
                withAnimation {
                    step.next()
                }
            } label: {
                Label("Get Started", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 200, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    var mantraView: some View {
        VStack(spacing: 30) {
                Text("Repeat The Following Mantra:")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .light ? .white: .black)
                
                Text(mantra)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .light ? .white: .black)
                    .lineSpacing(10)
            
            HStack(spacing: 20) {
                ForEach(1..<4, id: \.self) { i in
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(numberOfTimesMantraSaid >= i ? Color.green : Color.secondary)
                        .frame(maxHeight: 40)
                }
            }
            
            if isRecording {
                VStack(spacing: 15) {
                    Label("Listening...", systemImage: "microphone.fill")
                        .padding()
                        .frame(maxWidth: 200, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.tint)
                            //                            .fill(Color(uiColor: .secondarySystemFill))
                            //                            .opacity(0.9)
                        }
                    
                    Button {
                        withAnimation {
                            step.next()
                        } completion: {
                            endTranscription()
                        }
                    } label: {
                        Label("Skip", systemImage: "chevron.forward")
                            .labelStyle(.titleOnly)
                            .foregroundStyle(.tint)
                            .padding()
                            .frame(maxWidth: 200, alignment: .center)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            }
//                            .background {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .fill(Color(uiColor: .systemFill))
//                                    .opacity(0.2)
//                            }
                    }
                }
            }
        }
        .onChange(of: numberOfTimesMantraSaid) {
            guard numberOfTimesMantraSaid >= 3 else { return }
            Task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation {
                    step.next()
                } completion: {
                    endTranscription()
                }
            }
        }
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
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Button(action: stepManager.next) {
                Label("Continue", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 200, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
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
