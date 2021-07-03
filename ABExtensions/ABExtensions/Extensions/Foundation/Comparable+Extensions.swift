//
//  Comparable+Extensions.swift
//  ABExtensions
//
//  Created by Andy Brown on 03/07/2021.
//

import Foundation

public extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }

    func constrained(min: Self) -> Self {
        max(self, min)
    }

    func constrained(max: Self) -> Self {
        min(self, max)
    }
}
