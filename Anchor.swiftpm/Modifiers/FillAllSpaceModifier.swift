//
//  FillAllSpaceModifier.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

struct FillAllSpaceModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                content
                Spacer()
            }
            Spacer()
        }
    }
}

extension View {
    func fillSpaceAvailable() -> some View {
        modifier(FillAllSpaceModifier())
    }
}
