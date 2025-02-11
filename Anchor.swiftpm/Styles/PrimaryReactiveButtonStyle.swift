//
//  PrimaryReactiveButtonStyle.swift
//  Anchor
//
//  Created by Morris Richman on 2/10/25.
//

import SwiftUI

struct PrimaryReactiveButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            userResponseController.playSoundEffect(.primaryClick)
            configuration.trigger()
        } label: {
            configuration.label
        }
    }
}

extension PrimitiveButtonStyle where Self == PrimaryReactiveButtonStyle {
    static var reactive: PrimaryReactiveButtonStyle { get { .init() } set{} }
}

struct PrimaryReactiveBorderedButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            userResponseController.playSoundEffect(.primaryClick)
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(.bordered)
    }
}

extension PrimitiveButtonStyle where Self == PrimaryReactiveBorderedButtonStyle {
    static var reactiveBordered: PrimaryReactiveBorderedButtonStyle { get { .init() } set{} }
}


struct PrimaryReactiveBorderedProminentButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            userResponseController.playSoundEffect(.primaryClick)
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(.borderedProminent)
    }
}

extension PrimitiveButtonStyle where Self == PrimaryReactiveBorderedProminentButtonStyle {
    static var reactiveBorderedProminent: PrimaryReactiveBorderedProminentButtonStyle { get { .init() } set{} }
}
