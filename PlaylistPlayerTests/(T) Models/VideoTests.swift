//
//  VideoTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 18/03/2021.
//

import XCTest
import VideoQueuePlayer
@testable import PlaylistPlayer

final class VideoTests: XCTestCase {

    func testInitVideo() throws {
        let url = createTempDataAndReturnURL()
        
        let video = Video(id: UUID(), url: url, filename: "test-filename", duration: Time(seconds: 20), thumbnailFilename: nil)

        // Encode to data
        let encoder = JSONEncoder()
        let data = try encoder.encode(video)

        // Decode from data
        let decoder = JSONDecoder()
        let decodedVideo = try decoder.decode(Video.self, from: data)

        XCTAssertEqual(video, decodedVideo)
    }
    
    private func createTempDataAndReturnURL() -> URL {
        let tempPath = NSTemporaryDirectory() + UUID().uuidString
        try? FileManager.default.removeItem(atPath: tempPath)
        let tempURL = URL(fileURLWithPath: tempPath)
        let data = Data()
        try! data.write(to: tempURL)
        return tempURL
    }
}
