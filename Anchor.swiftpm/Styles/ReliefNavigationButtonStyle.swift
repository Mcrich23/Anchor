//
//  ReliefNavigationButtonStyle.swift
//  Anchor
//
//  Created by Morris Richman on 2/3/25.
//

import SwiftUI

struct ReliefNavigationButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle(radius: 6))
        .background(Color(uiColor: .systemBackground).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

extension PrimitiveButtonStyle where Self == ReliefNavigationButtonStyle {
    static var reliefNavigation: ReliefNavigationButtonStyle { get { .init() } set{} }
}
