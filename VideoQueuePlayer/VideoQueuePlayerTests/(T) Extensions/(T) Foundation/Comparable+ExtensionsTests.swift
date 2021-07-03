//
//  Comparable+ExtensionsTests.swift
//  VideoQueuePlayerTests
//
//  Created by Andy Brown on 03/07/2021.
//

import XCTest
@testable import VideoQueuePlayer

final class ComparableExtensionsTests: XCTestCase {

    func test_clampingWithinRange_numberUnchanged() {

        let clamped = 5.clamped(to: 0...10)

        XCTAssertEqual(clamped, 5)
    }

    func test_clampingLowerThanRange_numberIsMinimum() {

        let clamped = 5.clamped(to: 10...10)

        XCTAssertEqual(clamped, 10)
    }


    func test_clampingHigherThanRange_numberIsMaximum() {

        let clamped = 10.clamped(to: 0...5)

        XCTAssertEqual(clamped, 5)
    }
}
