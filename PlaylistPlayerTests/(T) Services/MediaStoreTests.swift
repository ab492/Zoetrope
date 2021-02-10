//
//  MediaStoreTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 09/02/2021.
//

import XCTest
@testable import PlaylistPlayer

class MediaStoreTests: XCTestCase {

    // MARK: - Properties and Setup

    private var temporaryFilePath: URL!
    private let fileManager = FileManager()

    override func setUp() {
        super.setUp()

        temporaryFilePath = makeTemporaryFilePathForTest()
    }

    func test_initPlaylistStore_doesntCreateFileOnDisk() {
        makeSUT()

        XCTAssertFalse(fileManager.fileExists(atPath: temporaryFilePath.path))
    }

    func test_copyItemToStore_CopiesItemWithoutRemovingOriginal() {
        let urlToCopy = createDataBlobAtDifferentTemporaryLocation(filename: "01.mov")
        let sut = makeSUT()

        _ = try? sut.copyItemToStore(from: urlToCopy)

        XCTAssertTrue(fileManager.fileExists(atPath: temporaryFilePath.appendingPathComponent("01.mov").path))
        XCTAssertTrue(fileManager.fileExists(atPath: urlToCopy.path))
    }

    func test_copyItemToStore_ReturnsRelativeURL() {
        let urlToCopy = createDataBlobAtDifferentTemporaryLocation(filename: "01.mov")
        let sut = makeSUT()

        let relativeURL = try? sut.copyItemToStore(from: urlToCopy)

        let expectedURL = temporaryFilePath.appendingPathComponent("01.mov").relativePath

        XCTAssertEqual(relativeURL, expectedURL)
    }

    func test_retrievingURLFromRelativePath_worksCorrectly() {
        let existingPath = temporaryFilePath.appendingPathComponent("01.mov")
        given_thereAlreadyExistsAFileAt(url: existingPath)

        let sut = makeSUT()

        let url = sut.urlForItemAt(relativePath: existingPath.relativePath)

        XCTAssertEqual(url, existingPath)
    }

    // TODO: Test adding multiple of the same item
}

// MARK: - Helpers

extension MediaStoreTests {
    @discardableResult private func makeSUT() -> MediaStoreImpl {
        MediaStoreImpl(location: temporaryFilePath)
    }

    private func makeTemporaryFilePathForTest() -> URL {
        let path = NSTemporaryDirectory() + UUID().uuidString
        try? FileManager.default.removeItem(atPath: path)
        return URL(fileURLWithPath: path)
    }

    // References a different temporary location to that of the temporary location belonging to the media store.
    private func createDataBlobAtDifferentTemporaryLocation(filename: String) -> URL {
        let path = NSTemporaryDirectory() + filename
        try? FileManager.default.removeItem(atPath: path)
        let url = URL(fileURLWithPath: path)

        let data = Data()
        try? data.write(to: url)
        return url
    }

    private func given_thereAlreadyExistsAFileAt(url: URL) {
        let data = Data()
        try? data.write(to: url)
    }
}


