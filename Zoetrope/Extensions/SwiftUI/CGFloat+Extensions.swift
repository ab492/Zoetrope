//
//  CGFloat+Extensions.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 26/01/2021.
//

import CoreGraphics

extension CGFloat {

    /// Maps a `CGFloat` from it's position between two points (`fromRange`) to it's relative position between a different set of points (`toRange`). For example, let's say we have a slider (min: 0, max: 100, value: 60) with a bounds (minX: 0, maxX: 1000), this function will map the value to it's correct position.
    /// - Parameters:
    ///   - from: The base range to map from (example: 0-100)
    ///   - to: The range you want to map to (example: 500-1000)
    /// - Returns: The relative position of the point along the `toRange`.
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {

        let value = self.clamped(to: from)

        let fromRange = from.upperBound - from.lowerBound
        let toRange = to.upperBound - to.lowerBound

        // Since we're diving by `fromRange`, we must check it's not zero.
        guard fromRange > 0 else { return 0 }

        let result = (((value - from.lowerBound) / fromRange) * toRange) + to.lowerBound
        return result
    }
}
