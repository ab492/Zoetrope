//
//  TimeFormatterTests.swift
//  QuickfireTests
//
//  Created by Andy Brown on 17/12/2020.
//

import XCTest
@testable import PlaylistPlayer

class TimeFormatterTests: XCTestCase {

    func test_SingleDigitSeconds_UnderAMinute() {
        let formattedString = TimeFormatter.string(from: 5)

        XCTAssertEqual(formattedString, "00:05")
    }

    func test_DoubleDigitSeconds_UnderAMinute() {
        let formattedString = TimeFormatter.string(from: 25)

        XCTAssertEqual(formattedString, "00:25")
    }

    func test_SingleDigitSeconds_OverAMinute() {
        let formattedString = TimeFormatter.string(from: 63)

        XCTAssertEqual(formattedString, "01:03")
    }

    func test_DoubleDigitSeconds_OverAMinute() {
        let formattedString = TimeFormatter.string(from: 73)

        XCTAssertEqual(formattedString, "01:13")
    }

    func test_DoubleDigitMinutes() {
        let formattedString = TimeFormatter.string(from: 603)

        XCTAssertEqual(formattedString, "10:03")
    }

    func test_SingleDigitHours() {
        let formattedString = TimeFormatter.string(from: 6723)

        XCTAssertEqual(formattedString, "01:52:03")
    }

    func test_DoubleDigitHours() {
        let formattedString = TimeFormatter.string(from: 14940)

        XCTAssertEqual(formattedString, "04:09:00")
    }
}
