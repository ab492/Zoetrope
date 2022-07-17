//
//  ThumbnailServiceTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import XCTest
@testable import PlaylistPlayer

final class ThumbnailServiceTests: XCTestCase {

    private var mockThumbnailStore: MockThumbnailStore!

    override func setUp() {
        super.setUp()

        mockThumbnailStore = MockThumbnailStore()
    }

    func test_removeThumbnail_removesFromStoreAndRemovesPropertyFromVideoModel() {
        let video = makeVideo(thumbnailFilename: "test-thumbnail")

        let sut = makeSUT()

        sut.removeThumbnail(for: video)

        XCTAssertEqual(mockThumbnailStore.deletedThumbnails.last, "test-thumbnail")
        XCTAssertNil(video.thumbnailFilename)
    }

    func test_cleanupStoreWorksCorrectly() {
        given_thumbnailStoreContains(filenames: ["test-thumbnail-1", "test-thumbnail-2", "test-thumbnail-3", "test-thumbnail-4"])
        let video1 = makeVideo(thumbnailFilename: "test-thumbnail-1")
        let video2 = makeVideo(thumbnailFilename: "test-thumbnail-2")
        let sut = makeSUT()

        sut.cleanupStoreOfAllExcept(requiredVideos: [video1, video2])

        XCTAssertEqual(Set(mockThumbnailStore.deletedThumbnails), Set(["test-thumbnail-3", "test-thumbnail-4"]))
    }

    private func makeSUT() -> ThumbnailServiceImpl {
        ThumbnailServiceImpl(thumbnailStore: mockThumbnailStore)
    }

    private func given_thumbnailStoreContains(filenames: [String]) {
        mockThumbnailStore.allThumbnailFilenames = filenames
    }

    private func makeVideo(thumbnailFilename: String) -> VideoModel {
        let video = VideoBuilder().build()
        video.thumbnailFilename = thumbnailFilename
        return video
    }

}
