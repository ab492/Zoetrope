////
////  PlaylistPlayerViewModel-Bookmarks.swift
////  PlaylistPlayerTests
////
////  Created by Andy Brown on 24/03/2021.
////
//
//import XCTest
//@testable import PlaylistPlayer
//
//extension PlaylistPlayerViewModelTests {
//    
//    // MARK: - Current Bookmarks
//
//    func test_viewModelCorrectlyReportsCurrentBookmarks() {
//        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 21))
//        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 30), timeOut: MediaTime(seconds: 40))
//        let bookmark4 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3, bookmark4])
//        given_playerIsAtTime(MediaTime(seconds: 21))
//
//        let sut = makeSUT()
//
//        XCTAssertEqual(sut.currentBookmarks, [bookmark1, bookmark2])
//    }
//
//    func test_viewModelCorrectlyReportsNoCurrentBookmarks() {
//        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 21))
//        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 30), timeOut: MediaTime(seconds: 40))
//        let bookmark4 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3, bookmark4])
//        given_playerIsAtTime(MediaTime(seconds: 60))
//
//        let sut = makeSUT()
//
//        XCTAssertEqual(sut.currentBookmarks, [])
//    }
//
//    // MARK: - Next Bookmark
//
//    func test_nextBookmark_isReportedCorrectly_ifSkippingFromCurrentBookmark() {
//        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 21))
//        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 30), timeOut: MediaTime(seconds: 40))
//        let bookmark4 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3, bookmark4])
//        given_playerIsAtTime(MediaTime(seconds: 21))
//
//        let sut = makeSUT()
//        sut.nextBookmark()
//
//        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark3.timeIn)
//    }
//
//    func test() {
//        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 21))
//        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 30), timeOut: MediaTime(seconds: 40))
//        let bookmark4 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3, bookmark4])
//        given_playerIsAtTime(MediaTime(seconds: 10))
//
//        let sut = makeSUT()
//        sut.nextBookmark()
//
//        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark1.timeIn)
//
//        sut.nextBookmark()
//        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark2.timeIn)
//    }
//
//
//    // MARK: - Givens
//
//    private func given_currentlyPlayingVideoHasBookmarks(_ bookmarks: [Video.Bookmark]) {
//        let video = createVideoWithBookmarks(bookmarks)
//        mockPlaylistPlayer.currentlyPlayingVideo = video
//    }
//
//    private func given_playerIsAtTime(_ time: MediaTime) {
//        mockPlaylistPlayer.currentTime = time
//    }
//
//    // MARK: - Helpers
//
//    private func createBookmark(timeIn: MediaTime, timeOut: MediaTime) -> Video.Bookmark {
//        Video.Bookmark(id: UUID(), timeIn: timeIn, timeOut: timeOut, noteType: .text(""))
//    }
//
//    private func createVideoWithBookmarks(_ bookmarks: [Video.Bookmark]) -> Video {
//        let video = VideoBuilder().build()
//
//        for bookmark in bookmarks {
//            video.addBookmark(bookmark)
//        }
//        return video
//    }
//}
