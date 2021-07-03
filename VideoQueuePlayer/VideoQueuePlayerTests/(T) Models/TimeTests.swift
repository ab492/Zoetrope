//
//  TimeTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 21/03/2021.
//

import XCTest
@testable import VideoQueuePlayer

class TimeTests: XCTestCase {

    func test_initTimeWithSeconds() {
        let time = Time(seconds: 30)

        XCTAssertEqual(time.seconds, 30)
    }

    func test_timeIsComparable() {
        let time1 = Time(seconds: 10)
        let time2 = Time(seconds: 20)

        XCTAssertTrue(time1 < time2)
    }
}
