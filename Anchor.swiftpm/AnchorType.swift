//
//  AnchorType.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import Foundation
import SwiftUI

enum AnchorType: String, CaseIterable {
    case migraine = "Migraine"
    case panicAttack = "Panic Attack"
    
    var color: Color {
        switch self {
        case .migraine:
            return .init(.migraineTint)
        case .panicAttack:
            return .indigo
        }
    }
}

extension Color {
    init(_ colorResource: ColorResource) {
        self.init(uiColor: .init(resource: colorResource))
    }
}
