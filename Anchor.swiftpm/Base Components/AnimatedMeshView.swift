//
//  AnimatedMeshView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//
// Source: https://designcode.io/swiftui-handbook-mesh-gradient

import Foundation
import Combine
import SwiftUI

actor AnimatedMeshViewModel: ObservableObject {
    @Published @MainActor fileprivate(set) var time: Float = 0.0
    @Published @MainActor var speed: TimeInterval = 0.009
    
    @MainActor
    var task: Task<Void, Error>?
    
//    init() {
//        runTimer()
//    }
    
    private func runTimer() {
        Task { @MainActor in
            self.task?.cancel()
            self.task = Task { @MainActor [self] in
                while true {
                    try? await Task.sleep(for: .seconds(speed*10))
                    time += 0.2
                }
            }
        }
        
    }
    
    @MainActor
    func sinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        return midPoint + amplitude * sin(timeScale * t + offset)
    }
    
    @MainActor
    var points: [SIMD2<Float>] {
        [
            .init(0, 0), .init(0.5, 0), .init(1, 0),

            [sinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: time), sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: time)],
            [sinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: time), sinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: time)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: time), sinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: time)],
            [sinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: time), sinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: time)],
            [sinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: time), sinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: time)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: time), sinInRange(1.3...1.7, offset: 0.47, timeScale: 0.342, t: time)]
        ]
    }
}

struct AnimatedMeshView: View {
    let colors: [Color]
    let speed: TimeInterval
    init(colors: [Color], speed: TimeInterval = 0.009, viewModel: AnimatedMeshViewModel = .init()) {
        self.colors = colors
        self.viewModel = viewModel
        self.speed = speed
    }
    
    @ObservedObject var viewModel: AnimatedMeshViewModel

    var body: some View {
        MeshGradient(width: 3, height: 3, points: viewModel.points, colors: colors)
        .background(.black)
        .ignoresSafeArea()
        .onChange(of: speed, initial: true) { _, newValue in
            viewModel.speed = speed
        }
    }
}
