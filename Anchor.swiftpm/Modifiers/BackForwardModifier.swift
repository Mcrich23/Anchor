//
//  File.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

struct BackForwardModifier: ViewModifier {
    let isBack: Bool
    func body(content: Content) -> some View {
        content
            .transition(
                isBack ?
                    .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
                :
                    .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
            )
    }
}
extension View {
    func backForward(isBack: Bool) -> some View {
        modifier(BackForwardModifier(isBack: isBack))
    }
}
