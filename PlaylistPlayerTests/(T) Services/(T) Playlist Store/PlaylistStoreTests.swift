//
//  PlaylistStoreTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 06/02/2021.
//

import XCTest
@testable import PlaylistPlayer

class PlaylistStoreTests: XCTestCase {

    // MARK: - Properties and Setup

    private var temporaryFilePath: URL!
    private let fileManager = FileManager()

    override func setUp() {
        super.setUp()

        temporaryFilePath = makeTemporaryFilePathForTest()
    }

    // MARK: - Tests

    func test_initPlaylistStore_doesntCreateFileOnDisk() {
        makeSUT()

        XCTAssertFalse(fileManager.fileExists(atPath: temporaryFilePath.path))
    }

    func test_savingPlaylistsForFirstTime_createsFileOnDisk() {
        let playlists = testPlaylists()
        let sut = makeSUT()

        sut.save(playlists)

        XCTAssertTrue(fileManager.fileExists(atPath: temporaryFilePath.path))
    }

    func test_savingAndRetrievingPlaylists() {
        let playlists = testPlaylists()
        let sut = makeSUT()
        sut.save(playlists)

        let fetchedPlaylists = sut.fetchPlaylists()

        XCTAssertEqual(fetchedPlaylists, playlists)
    }
}

// MARK: - Helpers

extension PlaylistStoreTests {
    @discardableResult private func makeSUT() -> PlaylistStoreImpl {
        PlaylistStoreImpl(location: temporaryFilePath)
    }

    private func makeTemporaryFilePathForTest() -> URL {
        let path = NSTemporaryDirectory() + UUID().uuidString
        try? FileManager.default.removeItem(atPath: path)
        return URL(fileURLWithPath: path)
    }

    private func testPlaylists() -> [Playlist] {
        [
            Playlist(id: UUID(), name: "Test Playlist 1", videos: [VideoBuilder().build()]),
            Playlist(id: UUID(), name: "Test Playlist 2", videos: [VideoBuilder().build()]),
            Playlist(id: UUID(), name: "Test Playlist 3", videos: [VideoBuilder().build()])
        ]
    }
}

