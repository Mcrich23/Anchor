//
//  UserResponseController.swift
//  Anchor
//
//  Created by Morris Richman on 2/9/25.
//

import Foundation
import AVFoundation
import SwiftUI

actor UserResponseController: ObservableObject {
    private var avplayer: AVAudioPlayer?
    private let musicURL: URL? = Bundle.main.url(forResource: "Tranquility – www.fesliyanstudios.com", withExtension: "mp3")
    @AppStorage("shouldPlayMusic") @MainActor private(set) var shouldPlayMusic = true
    private let audioVolume: Float = 1
    private let audioFadeDuration: TimeInterval = 1.5
    
    init() {
        Task {
            if await shouldPlayMusic {
                await playMusic()
            }
        }
    }
    
    func appEnteredBackground() {
        avplayer?.setVolume(0, fadeDuration: 0.2)
    }
    
    func appEnteredForeground() {
        avplayer?.setVolume(audioVolume, fadeDuration: 0.2)
    }
    
    func playMusic() {
        Task { @MainActor in
            shouldPlayMusic = true
        }
        guard let musicURL = musicURL else { return }
        guard avplayer == nil else {
            avplayer?.setVolume(audioVolume, fadeDuration: audioFadeDuration)
            return
        }
        do {
            avplayer = try AVAudioPlayer(contentsOf: musicURL)
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            avplayer?.setVolume(audioVolume, fadeDuration: 0)
            avplayer?.play()
            avplayer?.numberOfLoops = -1
        } catch {
            print("Failed to play music. \(error)")
        }
    }
    
    func stopMusic() {
        Task { @MainActor in
            shouldPlayMusic = false
        }
        avplayer?.setVolume(0, fadeDuration: audioFadeDuration)
    }
    
    func toggleMusic() {
        Task { @MainActor [self] in
            await toggleMusic(!shouldPlayMusic)
        }
    }
    
    func toggleMusic(_ bool: Bool) {
        Task {
            switch bool {
            case true: playMusic()
            case false: stopMusic()
            }
        }
    }
}

struct AudioPlayerButtonView: View {
    @EnvironmentObject var userResponseController: UserResponseController
    var body: some View {
        Button {
            Task {
                await userResponseController.toggleMusic()
            }
        } label: {
            Label(userResponseController.shouldPlayMusic ? "Play Music" : "Stop Music", systemImage: userResponseController.shouldPlayMusic ? "speaker.fill" : "speaker.slash.fill")
                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
            .labelStyle(.iconOnly)
            .font(.largeTitle)
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
        }
        .foregroundStyle(.white)
        .animation(.default, value: userResponseController.shouldPlayMusic)
    }
}
