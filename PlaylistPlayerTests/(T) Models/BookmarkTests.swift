//
//  BookmarkTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 21/03/2021.
//

import XCTest
@testable import PlaylistPlayer

// TODO: Check a bookmark can't have the times backwards (i.e. time out less than time in
// TODO: Negative time!
// TODO: What about if the bookmark is longer than the video?!

class BookmarkTests: XCTestCase {

    // MARK: - Creating Bookmark

    func test_bookmarksAreReturnedInSortedOrderByTimeIn() {
        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 6), timeOut: MediaTime(seconds: 7))
        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 1), timeOut: MediaTime(seconds: 3))
        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 0.5), timeOut: MediaTime(seconds: 2))

        let video = createVideoWithBookmarks([bookmark1, bookmark2, bookmark3])

        XCTAssertEqual(video.bookmarks, [bookmark3, bookmark2, bookmark1])
    }

    func test_ifBookmarkIsCreatedWithTimeOutLessThanTimeIn_thenDefaultsToTimeIn() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 5), timeOut: MediaTime(seconds: 4))

        XCTAssertEqual(bookmark.timeIn, MediaTime(seconds: 5))
        XCTAssertEqual(bookmark.timeOut, MediaTime(seconds: 5))
    }

    func test_ifBookmarkIsCreatedWithNegativeTime_defaultsToZero() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: -30), timeOut: MediaTime(seconds: 20))

        XCTAssertEqual(bookmark.timeIn, MediaTime(seconds: 0))
        XCTAssertEqual(bookmark.timeOut, MediaTime(seconds: 20))
    }

    func test_ifBookmarkIsCreatedWithTimeOutLessThanTimeIn_defaultsToTimeIn() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 60), timeOut: MediaTime(seconds: 30))

        XCTAssertEqual(bookmark.timeIn, MediaTime(seconds: 60))
        XCTAssertEqual(bookmark.timeOut, MediaTime(seconds: 60))
    }

    // MARK: - Editing Bookmark

    func test_updatingTimeIn() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 6), timeOut: MediaTime(seconds: 7))

        bookmark.setTimeIn(MediaTime(seconds: 5))

        XCTAssertEqual(bookmark.timeIn, MediaTime(seconds: 5))
        XCTAssertEqual(bookmark.timeOut, MediaTime(seconds: 7))
    }

    func test_updatingTimeOut() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 6), timeOut: MediaTime(seconds: 7))

        bookmark.setTimeOut(MediaTime(seconds: 9))

        XCTAssertEqual(bookmark.timeIn, MediaTime(seconds: 6))
        XCTAssertEqual(bookmark.timeOut, MediaTime(seconds: 9))
    }

    func test_updatingTimeInToGreaterThanTimeOut_defaultsToTimeOut() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 10), timeOut: MediaTime(seconds: 20))

        bookmark.setTimeIn(MediaTime(seconds: 25))

        XCTAssertEqual(bookmark.timeIn, MediaTime(seconds: 20))
        XCTAssertEqual(bookmark.timeOut, MediaTime(seconds: 20))
    }

    func test_updatingTimeOutToLessThanTimeIn_defaultsToTimeIn() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 10), timeOut: MediaTime(seconds: 20))

        bookmark.setTimeOut(MediaTime(seconds: 5))

        XCTAssertEqual(bookmark.timeIn, MediaTime(seconds: 10))
        XCTAssertEqual(bookmark.timeOut, MediaTime(seconds: 10))
    }

    // MARK: - Helpers

    private func createBookmark(timeIn: MediaTime, timeOut: MediaTime) -> Video.Bookmark {
        Video.Bookmark(id: UUID(), timeIn: timeIn, timeOut: timeOut)
    }

    private func createVideoWithBookmarks(_ bookmarks: [Video.Bookmark]) -> Video {
        let video = VideoBuilder().build()

        for bookmark in bookmarks {
            video.addBookmark(bookmark)
        }
        return video
    }

}
