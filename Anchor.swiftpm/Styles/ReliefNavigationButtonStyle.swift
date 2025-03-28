//
//  ReliefNavigationButtonStyle.swift
//  Anchor
//
//  Created by Morris Richman on 2/3/25.
//

import SwiftUI

struct ReliefNavigationButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(.reactiveBordered)
        .buttonBorderShape(.roundedRectangle(radius: 6))
        .background(Color(uiColor: .systemBackground).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .keyboardShortcut(.return, modifiers: .command)
    }
}

extension PrimitiveButtonStyle where Self == ReliefNavigationButtonStyle {
    static var reliefNavigation: ReliefNavigationButtonStyle { get { .init() } set{} }
}

struct ReliefBackNavigationButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var userResponseController: UserResponseController
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(.secondaryReactiveBordered)
        .buttonBorderShape(.roundedRectangle(radius: 6))
        .background(Color(uiColor: .systemBackground).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

extension PrimitiveButtonStyle where Self == ReliefBackNavigationButtonStyle {
    static var reliefBackNavigation: ReliefBackNavigationButtonStyle { get { .init() } set{} }
}
