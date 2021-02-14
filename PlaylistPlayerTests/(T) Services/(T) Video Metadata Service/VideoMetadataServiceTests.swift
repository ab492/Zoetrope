//
//  VideoMetadataServiceTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import XCTest
@testable import PlaylistPlayer

final class VideoMetadataServiceTests: BaseTestCase {

    private var mockDurationCalculator: MockDurationCalculator!

    override func setUp() {
        super.setUp()

        mockDurationCalculator = MockDurationCalculator()
    }

    func test_removeMetadata_callsRemoveOnThumbnailServiceAndBookmarkStore() {
        var video = VideoBuilder().thumbnailFilename("testThumbnail").build()
        let sut = makeSUT()

        sut.removeMetadata(for: &video)
        
        XCTAssertEqual(Current.mockThumbnailService.removeThumbnailCallCount, 1)
        XCTAssertEqual(Current.mockSecurityScopedBookmarkStore.lastRemovedBookmarkId, video.id)
    }
}

extension VideoMetadataServiceTests {
    
    private func makeSUT() -> VideoMetadataService {
        VideoMetadataServiceImpl(durationCalculator: mockDurationCalculator)
    }

}

