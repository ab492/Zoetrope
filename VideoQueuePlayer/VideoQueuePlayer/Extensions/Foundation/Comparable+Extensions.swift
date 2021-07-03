//
//  Comparable+Extensions.swift
//  VideoQueuePlayer
//
//  Created by Andy Brown on 03/07/2021.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
