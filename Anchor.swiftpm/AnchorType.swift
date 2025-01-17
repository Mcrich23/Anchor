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
            return .green
        case .panicAttack:
            return .indigo
        }
    }
}
