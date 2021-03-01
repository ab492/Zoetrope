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
        let video = VideoBuilder().thumbnailFilename("test-thumbnail").build()

        let sut = makeSUT()

        sut.removeThumbnail(for: video)

        XCTAssertEqual(mockThumbnailStore.lastDeletedThumbnail, "test-thumbnail")
        XCTAssertNil(video.thumbnailFilename)
    }

    private func makeSUT() -> ThumbnailServiceImpl {
        ThumbnailServiceImpl(thumbnailStore: mockThumbnailStore)
    }

}
