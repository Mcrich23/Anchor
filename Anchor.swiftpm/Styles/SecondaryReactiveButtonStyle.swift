//
//  SecondaryReactiveButtonStyle.swift
//  Anchor
//
//  Created by Morris Richman on 2/10/25.
//

import SwiftUI

struct SecondaryReactiveButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            userResponseController.playSoundEffect(.secondaryClick)
            configuration.trigger()
        } label: {
            configuration.label
        }
    }
}

extension PrimitiveButtonStyle where Self == SecondaryReactiveButtonStyle {
    static var secondaryReactive: SecondaryReactiveButtonStyle { get { .init() } set{} }
}

struct SecondaryReactiveBorderedButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            userResponseController.playSoundEffect(.secondaryClick)
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(.bordered)
    }
}

extension PrimitiveButtonStyle where Self == SecondaryReactiveBorderedButtonStyle {
    static var secondaryReactiveBordered: SecondaryReactiveBorderedButtonStyle { get { .init() } set{} }
}


struct SecondaryReactiveBorderedProminentButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            userResponseController.playSoundEffect(.secondaryClick)
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(.borderedProminent)
    }
}

extension PrimitiveButtonStyle where Self == SecondaryReactiveBorderedProminentButtonStyle {
    static var secondaryReactiveBorderedProminent: SecondaryReactiveBorderedProminentButtonStyle { get { .init() } set{} }
}
