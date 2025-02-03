//
//  ViewSteps Enum Protocol.swift
//  Anchor
//
//  Created by Morris Richman on 2/3/25.
//

import Foundation

/// Implements next and previous mutating functions for an `enum`
/// Note: Requires conformance to `Int` before `ViewSteps` can function
protocol ViewSteps: CaseIterable, RawRepresentable where RawValue == Int {
    mutating func next()
    mutating func previous()
}


extension ViewSteps {
    mutating func next() {
        guard let next = Self(rawValue: self.rawValue+1) else { return }
        self = next
    }
    mutating func previous() {
        guard let next = Self(rawValue: self.rawValue-1) else { return }
        self = next
    }
}
