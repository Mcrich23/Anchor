//
//  UserResponseController.swift
//  Anchor
//
//  Created by Morris Richman on 2/9/25.
//

import Foundation
import AVFoundation
import SwiftUI

enum UserResponseControllerSoundEffect {
    case complete
    case primaryClick
    case secondaryClick
    
    var fileName: String {
        switch self {
        case .complete: "navigation-level-passed-pixabay"
        case .primaryClick: "primary-button-click-pixabay"
        case .secondaryClick: "secondary-click-button-pixabay"
        }
    }
}

actor UserResponseController: ObservableObject {
    // MARK: Sound Effects
    private var soundEffectAVPlayer: AVAudioPlayer?
    
    nonisolated func playSoundEffect(_ effect: UserResponseControllerSoundEffect) {
        Task {
            await self.playSoundEffect(effect)
        }
    }
    
    func playSoundEffect(_ effect: UserResponseControllerSoundEffect) async {
        guard let url = Bundle.main.url(forResource: effect.fileName, withExtension: "mp3") else {
            return
        }
        
        do {
            soundEffectAVPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectAVPlayer?.setVolume(1, fadeDuration: 0)
            soundEffectAVPlayer?.numberOfLoops = 0
            soundEffectAVPlayer?.play()
        } catch {
            print("Failed to play music. \(error)")
        }
    }
    
    // MARK: Music Stuff
    private var musicAVPlayer: AVAudioPlayer?
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
        musicAVPlayer?.setVolume(0, fadeDuration: 0.2)
    }
    
    func appEnteredForeground() {
        musicAVPlayer?.setVolume(audioVolume, fadeDuration: 0.2)
    }
    
    func playMusic() {
        Task { @MainActor in
            shouldPlayMusic = true
        }
        guard let musicURL = musicURL else { return }
        guard musicAVPlayer == nil else {
            musicAVPlayer?.setVolume(audioVolume, fadeDuration: audioFadeDuration)
            return
        }
        do {
            musicAVPlayer = try AVAudioPlayer(contentsOf: musicURL)
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            musicAVPlayer?.setVolume(audioVolume, fadeDuration: 0)
            musicAVPlayer?.numberOfLoops = -1
            musicAVPlayer?.play()
        } catch {
            print("Failed to play music. \(error)")
        }
    }
    
    func stopMusic() {
        Task { @MainActor in
            shouldPlayMusic = false
        }
        musicAVPlayer?.setVolume(0, fadeDuration: audioFadeDuration)
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
        .buttonStyle(.reactive)
    }
}
