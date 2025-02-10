//
//  DeviceRotationViewModifier.swift
//  Anchor
//
//  Created by Morris Richman on 1/17/25.
//

import Foundation
import SwiftUI

// Our custom view modifier to track rotation and
// call our action
private struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

extension EnvironmentValues {
    // Cannot set dynamic default because `UIDevice.current` is MainActor only
    @Entry var orientation: UIDeviceOrientation = .unknown
    @Entry var nonFlatOrientation: UIDeviceOrientation = .unknown
}
