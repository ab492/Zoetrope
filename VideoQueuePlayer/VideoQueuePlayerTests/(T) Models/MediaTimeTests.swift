//
//  MediaTimeTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 23/03/2021.
//

import XCTest
import CoreMedia
@testable import VideoQueuePlayer

class MediaTimeTests: XCTestCase {

    func test_mediaTime_mapsCorrectlyToCmTime() {
        let mediaTime = MediaTime(seconds: 0.9789111111111111)
        let expectedCmTime = CMTime(seconds: 0.9789111111111111, preferredTimescale: 600)

        XCTAssertEqual(CMTime(mediaTime: mediaTime), expectedCmTime)
    }

    func test_mediaTimeIsComparable() {
        let mediaTime1 = MediaTime(seconds: 30)
        let mediaTime2 = MediaTime(seconds: 40)

        XCTAssertTrue(mediaTime1 < mediaTime2)
    }

    func test_mediaTimeIsEquatable() {
        let mediaTime1 = MediaTime(seconds: 30)
        let mediaTime2 = MediaTime(seconds: 30)

        XCTAssertEqual(mediaTime1, mediaTime2)
    }
    
    func test_mediaTimeInitWithMinutes() {
        let mediaTime = MediaTime(minute: 30)
        
        mediaTime.seconds.verify(equals: 1800)
    }
    
    func test_mediaTimeInitWithHours() {
        let mediaTime = MediaTime(hour: 2)
        
        mediaTime.seconds.verify(equals: 7200)
    }
}
