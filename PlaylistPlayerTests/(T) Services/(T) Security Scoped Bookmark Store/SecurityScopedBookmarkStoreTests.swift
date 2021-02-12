//
//  SecurityScopedBookmarkStoreTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 11/02/2021.
//

import XCTest
@testable import PlaylistPlayer

class SecurityScopedBookmarkStoreTests: XCTestCase {

    // MARK: - Properties and Setup

    private var temporaryFilePath: URL!
    private let fileManager = FileManager()

    override func setUp() {
        super.setUp()

        temporaryFilePath = makeTemporaryFilePathForTest()
    }

    // MARK: - Tests

    func test_initBookmarkStore_doesntCreateFileOnDisk() {
        makeSUT()

        XCTAssertFalse(fileManager.fileExists(atPath: temporaryFilePath.path))
    }

    func test_savingDataForFirstTime_createsFileOnDisk() {
        let id = UUID()
        let tempURL = makeTemporaryFilePathForTest()
        guard let bookmark = SecurityScopedBookmark(id: id, securityScopedURL: tempURL) else {
            XCTFail("Should be able to create a bookmark")
            return
        }

        let sut = makeSUT()
        sut.add(bookmark: bookmark)

        XCTAssertTrue(fileManager.fileExists(atPath: temporaryFilePath.path))
    }

}

// MARK: - Helpers

extension SecurityScopedBookmarkStoreTests {
    @discardableResult private func makeSUT() -> SecurityScopedBookmarkStoreImpl {
        SecurityScopedBookmarkStoreImpl(location: temporaryFilePath)
    }

    private func makeTemporaryFilePathForTest() -> URL {
        let path = NSTemporaryDirectory() + UUID().uuidString
        try? FileManager.default.removeItem(atPath: path)
        return URL(fileURLWithPath: path)
    }
}




//
//    // MARK: - Tests
//

//

//
//    func test_savingAndRetrievingPlaylists() {
//        let playlists = testPlaylists()
//        let sut = makeSUT()
//        sut.save(playlists)
//
//        let fetchedPlaylists = sut.fetchPlaylists()
//
//        XCTAssertEqual(playlists, fetchedPlaylists)
//    }
//}
//
//// MARK: - Helpers
//
//extension PlaylistStoreTests {
//    @discardableResult private func makeSUT() -> PlaylistStoreImpl {
//        PlaylistStoreImpl(location: temporaryFilePath)
//    }
//
//    private func makeTemporaryFilePathForTest() -> URL {
//        let path = NSTemporaryDirectory() + UUID().uuidString
//        try? FileManager.default.removeItem(atPath: path)
//        return URL(fileURLWithPath: path)
//    }
//
//    private func testPlaylists() -> [Playlist] {
//        // TODO: How to include videos here?!
//        [
//            Playlist(id: UUID(), name: "Test Playlist 1", videos: []),
//            Playlist(id: UUID(), name: "Test Playlist 2", videos: []),
//            Playlist(id: UUID(), name: "Test Playlist 3", videos: [])
//        ]
//    }
//}
//
//
