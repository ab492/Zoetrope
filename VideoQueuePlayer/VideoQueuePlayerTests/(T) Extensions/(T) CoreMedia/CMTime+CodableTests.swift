//
//  CMTime+CodableTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 23/03/2021.
//

import CoreMedia
import XCTest
@testable import VideoQueuePlayer

class CMTime_CodableTests: XCTestCase {

    func testCodingAndDecoding() throws {

        let time = CMTime(seconds: 1.7521, preferredTimescale: .default)

        // Encode to data
        let encoder = JSONEncoder()
        let data = try encoder.encode(time)

        // Decode from data
        let decoder = JSONDecoder()
        let decodedTime = try decoder.decode(CMTime.self, from: data)

        XCTAssertEqual(decodedTime, time)
    }
}
