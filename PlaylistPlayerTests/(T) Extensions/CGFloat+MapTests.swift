//
//  CGFloat+MapTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 26/01/2021.
//

import XCTest
@testable import PlaylistPlayer

class CGFloat_MapTests: XCTestCase {

    func test_rangeStartingWithZero() {
        let fromRange: ClosedRange<CGFloat> = 0...100
        let toRange: ClosedRange<CGFloat> = 0...1000

        let mappedValue = CGFloat(60).map(from: fromRange, to: toRange)

        XCTAssertEqual(mappedValue, 600)
    }

    func test_rangeNotStartingWithZero() {
        let fromRange: ClosedRange<CGFloat> = 50...100
        let toRange: ClosedRange<CGFloat> = 1000...2000

        let mappedValue = CGFloat(75).map(from: fromRange, to: toRange)

        XCTAssertEqual(mappedValue, 1500)
    }

    func test_mappingToSmallerRange() {
        let fromRange: ClosedRange<CGFloat> = 1000...2000
        let toRange: ClosedRange<CGFloat> = 100...200

        let mappedValue = CGFloat(1800).map(from: fromRange, to: toRange)

        XCTAssertEqual(mappedValue, 180)
    }

    func test_mappingValueLowerThanRange_clampsToMinimum() {
        let fromRange: ClosedRange<CGFloat> = 0...100
        let toRange: ClosedRange<CGFloat> = 0...1000

        let mappedValue = CGFloat(-30).map(from: fromRange, to: toRange)

        XCTAssertEqual(mappedValue, 0)
    }

    func test_mappingValueGreaterThanRange_clampsToMaximum() {
        let fromRange: ClosedRange<CGFloat> = 0...100
        let toRange: ClosedRange<CGFloat> = 0...1000

        let mappedValue = CGFloat(110).map(from: fromRange, to: toRange)

        XCTAssertEqual(mappedValue, 1000)
    }

    func test_fromRangeOfZero_returns0() {
        let fromRange: ClosedRange<CGFloat> = 0.0...0.0
        let toRange: ClosedRange<CGFloat> = 0...1000

        let mappedValue = CGFloat(0).map(from: fromRange, to: toRange)

        XCTAssertEqual(mappedValue, 0)
    }
}
