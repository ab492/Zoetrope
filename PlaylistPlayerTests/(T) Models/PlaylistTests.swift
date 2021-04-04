//
//  Playlist+Tests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 06/02/2021.
//

import XCTest
@testable import PlaylistPlayer

class Playlist_Tests: XCTestCase {

    func testCodingAndDecoding() throws {

        let playlist = Playlist(id: UUID(), name: "Test Playlist 1", videos: [VideoBuilder().build()])

        // Encode to data
        let encoder = JSONEncoder()
        let data = try encoder.encode(playlist)

        // Decode from data
        let decoder = JSONDecoder()
        let decodedPlaylist = try decoder.decode(Playlist.self, from: data)

        XCTAssertEqual(decodedPlaylist, playlist)
    }

    func test_formattedCountWithNoItems() {
        let playlist = PlaylistBuilder().videos([]).build()

        XCTAssertEqual(playlist.formattedCount, "0 items")
    }

    func test_formattedCountWithOneItem() {
        let playlist = PlaylistBuilder().videos([VideoBuilder().build()]).build()

        XCTAssertEqual(playlist.formattedCount, "1 item")
    }

    func test_formattedCountWithMultipleItems() {
        let twoVideos = [VideoBuilder().build(), VideoBuilder().build()]
        let playlist = PlaylistBuilder().videos(twoVideos).build()

        XCTAssertEqual(playlist.formattedCount, "2 items")
    }
}
