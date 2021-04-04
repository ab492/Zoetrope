//
//  BookmarkListViewModelTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 04/04/2021.
//

import XCTest
@testable import PlaylistPlayer

final class BookmarkListViewModelTests: BaseTestCase {

    // MARK: - Properties and Setup

    private var mockPlaylistPlayer: MockPlaylistPlayer!

    override func setUp() {
        super.setUp()

        mockPlaylistPlayer = MockPlaylistPlayer()
    }

    // MARK: - Current Bookmarks

    func test_viewModelCorrectlyReportsCurrentBookmarks() {
        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 21))
        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 30), timeOut: MediaTime(seconds: 40))
        let bookmark4 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
        given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3, bookmark4])
        given_playerIsAtTime(MediaTime(seconds: 21))

        let sut = makeSUT()

        XCTAssertEqual(sut.currentBookmarks, [bookmark1, bookmark2])
    }

    func test_viewModelCorrectlyReportsNoCurrentBookmarks() {
        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 21))
        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 30), timeOut: MediaTime(seconds: 40))
        let bookmark4 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
        given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3, bookmark4])
        given_playerIsAtTime(MediaTime(seconds: 60))

        let sut = makeSUT()

        XCTAssertEqual(sut.currentBookmarks, [])
    }

    // MARK: - Time Formatting

    func test_viewModelCorrectlyFormatsTimeInAndTimeOut() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 21), timeOut: MediaTime(seconds: 30.2))
        given_currentlyPlayingVideoHasBookmarks([bookmark])

        let sut = makeSUT()

        XCTAssertEqual(sut.formattedTimeInForBookmark(bookmark), "00:21")
        XCTAssertEqual(sut.formattedTimeOutForBookmark(bookmark), "00:30")
    }

    // MARK: - Jumping to Start and End

    func test_goToStartOfBookmark_setsPlayerToCorrectTime() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
        given_currentlyPlayingVideoHasBookmarks([bookmark])
        given_playerIsAtTime(MediaTime(seconds: 21))

        let sut = makeSUT()
        sut.goToStartOfBookmark(bookmark)

        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark.timeIn)
    }

    func test_goToEndOfBookmark_setsPlayerToCorrectTime() {
        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
        given_currentlyPlayingVideoHasBookmarks([bookmark])
        given_playerIsAtTime(MediaTime(seconds: 21))

        let sut = makeSUT()
        sut.goToEndOfBookmark(bookmark)

        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark.timeOut)
    }

    // MARK: - Adding Bookmarks

    func test_addingBookmark_addsNewBookmarkWithCurrentPlayerTime() {
        given_thereIsACurrentlyPlayingVideo()
        given_playerIsAtTime(MediaTime(seconds: 21))

        let sut = makeSUT()

        XCTAssertEqual(sut.bookmarks.count, 0)
        sut.addBookmark()

        let newlyAddedBookmark = sut.bookmarks.first!
        XCTAssertEqual(newlyAddedBookmark.timeIn, MediaTime(seconds: 21))
        XCTAssertEqual(newlyAddedBookmark.timeOut, MediaTime(seconds: 21))
    }

    func test_addingBookmark_callsSaveOnPlaylistManager() {
        given_thereIsACurrentlyPlayingVideo()
        given_playerIsAtTime(MediaTime(seconds: 21))

        let sut = makeSUT()
        sut.addBookmark()

        XCTAssertEqual(Current.mockPlaylistManager.saveCallCount, 1)
    }
}

// MARK: - MakeSUT and Givens

extension BookmarkListViewModelTests {
    func makeSUT() -> BookmarkListView.ViewModel {
        BookmarkListView.ViewModel(playlistPlayer: mockPlaylistPlayer)
    }

    private func given_thereIsACurrentlyPlayingVideo() {
        mockPlaylistPlayer.currentlyPlayingVideo = createVideoWithBookmarks([])
    }

    private func given_currentlyPlayingVideoHasBookmarks(_ bookmarks: [Video.Bookmark]) {
        let video = createVideoWithBookmarks(bookmarks)
        mockPlaylistPlayer.currentlyPlayingVideo = video
    }

    private func given_playerIsAtTime(_ time: MediaTime) {
        mockPlaylistPlayer.currentTime = time
    }

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
