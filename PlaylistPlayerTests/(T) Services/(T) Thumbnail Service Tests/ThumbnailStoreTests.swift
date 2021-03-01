//
//  ThumbnailStoreTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import XCTest
@testable import PlaylistPlayer

final class ThumbnailStoreTests: XCTestCase {

    // MARK: - Properties and Setup

    private var temporaryDirectory: URL!
    private let fileManager = FileManager()

    override func setUp() {
        super.setUp()

        temporaryDirectory = makeTemporaryFilePathForTest()
    }

    // MARK: - Test Init

    func test_initThumbnailStore_doesntCreateFileOnDisk() {
        makeSUT()

        XCTAssertFalse(fileManager.fileExists(atPath: temporaryDirectory.path))
    }

    // MARK: - Test Saving Images

    func test_savingImage_worksCorrectly() {
        let testImage = createTestImage()
        let sut = makeSUT()

        try? sut.save(image: testImage, filename: "test-thumbnail")

        let expectedPath = temporaryDirectory.appendingPathComponent("test-thumbnail").appendingPathExtension("jpg").path
        XCTAssertTrue(fileManager.fileExists(atPath: expectedPath))
    }

    func test_savingImage_isReturnedInAllThumbnails() {
        let testImage = createTestImage()
        let sut = makeSUT()

        try? sut.save(image: testImage, filename: "test-thumbnail")

        XCTAssertEqual(sut.allThumbnails, ["test-thumbnail"])
    }
    
    // MARK: - Getting All Thumbnail Filenames

    func test_gettingAllThumbnails_returnsAllJpegs() {
        given_directoryContainsJpegsNamed(["test-thumbnail-1", "test-thumbnail-2", "test-thumbnail-3"])

        let sut = makeSUT()

        XCTAssertEqual(sut.allThumbnails, ["test-thumbnail-1", "test-thumbnail-2", "test-thumbnail-3"])
    }

    func test_gettingAllThumbnails_doesntReturnAnyOtherFileTypes() {
        given_directoryContainsJpegsNamed(["test-thumbnail-1", "test-thumbnail-2", "test-thumbnail-3"])
        given_directoryContainsOnePngAndOneMov()

        let sut = makeSUT()

        XCTAssertEqual(sut.allThumbnails, ["test-thumbnail-1", "test-thumbnail-2", "test-thumbnail-3"])
    }


}

// MARK: - Helpers and Givens

extension ThumbnailStoreTests {

    @discardableResult private func makeSUT() -> ThumbnailStoreImpl {
        ThumbnailStoreImpl(directory: temporaryDirectory)
    }

    private func makeTemporaryFilePathForTest() -> URL {
        let path = NSTemporaryDirectory() + UUID().uuidString
        try? FileManager.default.removeItem(atPath: path)
        return URL(fileURLWithPath: path)
    }

    private func createTestImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        UIGraphicsBeginImageContext(rect.size)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    private func given_directoryContainsJpegsNamed(_ names: [String]) {
        // First we must create the actual directory.
        try? fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)

        // Then add the dummy data
        for name in names {
            let data = Data()
            let url = temporaryDirectory.appendingPathComponent(name).appendingPathExtension("jpg")
            try? data.write(to: url)
        }
    }

    private func given_directoryContainsOnePngAndOneMov() {
        // First we must create the actual directory.
        try? fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)

        let fakeVideo = Data()
        let fakeVideoUrl = temporaryDirectory.appendingPathComponent("test-video").appendingPathExtension("mov")
        try? fakeVideo.write(to: fakeVideoUrl)


        let fakePng = Data()
        let fakePngUrl = temporaryDirectory.appendingPathComponent("test-png").appendingPathExtension("mov")
        try? fakePng.write(to: fakePngUrl)
    }

}
