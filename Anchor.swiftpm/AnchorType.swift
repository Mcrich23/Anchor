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
            return .migraineTint
        case .panicAttack:
            return .indigo
        }
    }
    
    var shortcutKey: KeyEquivalent {
        switch self {
        case .migraine:
                .init("m")
        case .panicAttack:
                .init("p")
        }
    }
}
