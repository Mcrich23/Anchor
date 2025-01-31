//
//  AnchorView.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import SwiftUI

struct AnchorView: View {
    let anchor: AnchorType
    
    var body: some View {
        Group {
            switch anchor {
            case .migraine:
                MigraineView()
            case .panicAttack:
                PanicAttackView()
            }
        }
        .accentColor(anchor.color)
        .tint(anchor.color)
    }
}
