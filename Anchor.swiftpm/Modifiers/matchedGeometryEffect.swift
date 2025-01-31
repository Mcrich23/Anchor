//
//  matchedGeometryEffect.swift
//  Anchor
//
//  Created by Morris Richman on 1/30/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func matchedGeometryEffect<ID: Hashable>(id: ID, in namespace: Namespace.ID?) -> some View {
        if let namespace {
            matchedGeometryEffect(id: id, in: namespace)
        } else {
            self
        }
    }
}
