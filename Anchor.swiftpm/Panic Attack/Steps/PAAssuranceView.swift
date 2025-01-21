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
                withAnimation {
                    step.next()
                }
            } label: {
                Label("Get Started", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 700, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    var mantraView: some View {
        VStack(spacing: 60) {
            Text("Repeat The Following Mantra:")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            
            Text("I am experiencing a panic attack. It is okay to feel this way. I don't need to escape it, just work with it.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
                .lineSpacing(10)
            
            if !speechRecognizer.transcript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(speechRecognizer.transcript)
                    .minimumScaleFactor(0.7)
            }
            Button {
                switch isRecording {
                case true:
                    endTranscription()
                case false:
                    startTranscription()
                }
            } label: {
                Label(isRecording ? "Stop Transcription" : "Start Transcription", systemImage: "microphone.fill")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 700, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    var conclusionView: some View {
        VStack(spacing: 40) {
            Text("Good Job!")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Text("Lets move on to grounding techniques.")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .light ? .white: .black)
            Button(action: stepManager.next) {
                Label("Continue", systemImage: "chevron.right")
                    .labelStyle(.titleOnly)
                    .frame(maxWidth: 700, alignment: .center)
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
