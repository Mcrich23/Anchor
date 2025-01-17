//
//  OppositeOrderLabelStyle.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

struct OppositeOrderLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == OppositeOrderLabelStyle {
    @MainActor @preconcurrency static var oppositeOrderLabelStyle: OppositeOrderLabelStyle { get { OppositeOrderLabelStyle() } }
}
