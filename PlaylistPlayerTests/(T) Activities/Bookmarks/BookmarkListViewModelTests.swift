////
////  BookmarkListViewModelTests.swift
////  PlaylistPlayerTests
////
////  Created by Andy Brown on 04/04/2021.
////
//
//import XCTest
//@testable import PlaylistPlayer

// TODO: Reimplement these tests.
//
//final class BookmarkListViewModelTests: BaseTestCase {
//
//    // MARK: - Properties and Setup
//
//    private var sut: BookmarkListView.ViewModel!
//    private var mockPlaylistPlayer: MockPlaylistPlayer!
//
//    override func setUp() {
//        super.setUp()
//
//        mockPlaylistPlayer = MockPlaylistPlayer()
//    }
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
//        makeSUT()
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
//        makeSUT()
//
//        XCTAssertEqual(sut.currentBookmarks, [])
//    }
//
//    // MARK: - Current Bookmark Thresholds
//
//    // Here we use a buffer time (+/- 0.1 seconds) to make up for the fact that the
//    // player doesn't report an update every single frame (which causes some current
//    // bookmarks to flicker).
//
//    func test_viewModelCorrectlyReportsBookmarksWithinThresholdBelowCurrentTime() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        given_playerIsAtTime(MediaTime(seconds: 19.9))
//
//        makeSUT()
//
//        XCTAssertEqual(sut.currentBookmarks, [bookmark])
//    }
//
//    func test_viewModelCorrectlyReportsNoBookmarksJustBelowThreshold() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        given_playerIsAtTime(MediaTime(seconds: 19.8))
//
//        makeSUT()
//
//        XCTAssertEqual(sut.currentBookmarks, [])
//    }
//
//    func test_viewModelCorrectlyReportsBookmarksWithinThresholdAboveCurrentTime() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        given_playerIsAtTime(MediaTime(seconds: 30.1))
//
//        makeSUT()
//
//        XCTAssertEqual(sut.currentBookmarks, [bookmark])
//    }
//
//    func test_viewModelCorrectlyReportsNoBookmarksJustAboveThreshold() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        given_playerIsAtTime(MediaTime(seconds: 30.2))
//
//        makeSUT()
//
//        XCTAssertEqual(sut.currentBookmarks, [])
//    }
//
//    // MARK: - Time Formatting
//
//    func test_viewModelCorrectlyFormatsTimeInAndTimeOut() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 21), timeOut: MediaTime(seconds: 30.2))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//
//        makeSUT()
//
//        XCTAssertEqual(sut.formattedTimeForBookmark(bookmark), "00:21-00:30")
//    }
//
//    func test_viewModelCorrectlyFormatsTimeWhenBookmarkIsOnlyOneFrame() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 21), timeOut: MediaTime(seconds: 21))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//
//        makeSUT()
//
//        XCTAssertEqual(sut.formattedTimeForBookmark(bookmark), "00:21")
//    }
//
//    // MARK: - Note Formatting
//
//    func test_viewModelCorrectlyReturnsNote_ifBookmarkHasOne() {
//        let bookmark = createBookmarkWith(note: "This is a test note")
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//
//        makeSUT()
//
//        XCTAssertEqual(sut.formattedNoteForBookmark(bookmark), "This is a test note")
//    }
//
//    func test_viewModelCorrectlyReturnsPlaceholder_ifBookmarkHasNoNote() {
//        let bookmark = createBookmarkWith(note: nil)
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//
//        makeSUT()
//
//        XCTAssertEqual(sut.formattedNoteForBookmark(bookmark), "No Note")
//    }
//
//    // MARK: - Jumping to Start and End
//
//    func test_goToStartOfBookmark_setsPlayerToCorrectTime() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        given_playerIsAtTime(MediaTime(seconds: 21))
//        makeSUT()
//
//        sut.goToStartOfBookmark(bookmark)
//
//        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark.timeIn)
//    }
//
//    func test_goToEndOfBookmark_setsPlayerToCorrectTime() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        given_playerIsAtTime(MediaTime(seconds: 21))
//        makeSUT()
//
//        sut.goToEndOfBookmark(bookmark)
//
//        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark.timeOut)
//    }
//
//    // MARK: - Adding Bookmarks
//
//    func test_addingBookmark_addsNewBookmarkWithCurrentPlayerTime() {
//        given_thereIsACurrentlyPlayingVideo()
//        given_playerIsAtTime(MediaTime(seconds: 21))
//        makeSUT()
//
//        XCTAssertEqual(sut.bookmarks.count, 0)
//        sut.addBookmark()
//
//        let newlyAddedBookmark = sut.bookmarks.first!
//        XCTAssertEqual(newlyAddedBookmark.timeIn, MediaTime(seconds: 21))
//        XCTAssertEqual(newlyAddedBookmark.timeOut, MediaTime(seconds: 21))
//    }
//
//    // MARK: - Looping Bookmark
//
//    func test_settingLoopOnBookmark_isReturnedCorrectly() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        makeSUT()
//
//        sut.bookmarkOnLoop = bookmark
//
//        XCTAssertEqual(sut.bookmarkOnLoop, bookmark)
//    }
//
//    func test_deletingCurrentlyLoopingBookmark_setsBookmarkOnLoopToNil() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        makeSUT()
//        given_currentlyPlayingVideoHasBookmarkOnLoop(bookmark: bookmark)
//
//        sut.remove(bookmarksAt: IndexSet(integer: 0)) // We've only got one bookmark so it must be index 0.
//
//        XCTAssertNil(sut.bookmarkOnLoop)
//    }
//
//    func test_whenSettingABookmarkToLoop_playerJumpsToStartFrame() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        makeSUT()
//
//        sut.bookmarkOnLoop = bookmark
//
//        XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, MediaTime(seconds: 40))
//    }
//
//    func test_whenCurrentlyPlayingVideoDidChange_bookmarkSetToNil() {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//        given_currentlyPlayingVideoHasBookmarks([bookmark])
//        makeSUT()
//        given_currentlyPlayingVideoHasBookmarkOnLoop(bookmark: bookmark)
//
//        // This would normally be done via the observers of `PlaylistPlayer` but as this is a simple test, I've just forced it.
//        sut.playbackDurationDidChange(to: MediaTime(seconds: 10))
//
//        XCTAssertNil(sut.bookmarkOnLoop)
//    }
//
//    // MARK: - Formatted Notes For Overlay
//
//    func test_multipleNotesOnSameTimecode_areFormattedOverMultipleLines() {
//        let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50), note: "Test note!")
//        let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 40), note: "Second test note.")
//        let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 41), note: "This is a third test note.")
//        given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3])
//        makeSUT()
//
//        given_playerIsAtTime(MediaTime(seconds: 40))
//
//        let formattedNote = sut.currentNotesFormattedForOverlay
//
//        XCTAssertEqual(formattedNote, "Test note!\nSecond test note.\nThis is a third test note.")
//    }
//
//    func test_noNotes_areFormattedAsEmptyString() {
//        makeSUT()
//
//        let formattedNote = sut.currentNotesFormattedForOverlay
//
//        XCTAssertEqual(formattedNote, "")
//    }
//
//    // MARK: - Adding Drawings
//
//    func test_bookmarkHasDrawingIsCorrectlyReported() {
//        makeSUT()
//        given_thereIsACurrentlyPlayingVideo()
//        given_playerIsAtTime(MediaTime(seconds: 20))
//
//        let testDrawingData = Data()
//        sut.addBookmarkForDrawing(data: testDrawingData)
//
//        XCTAssertEqual(sut.currentBookmarks.first?.hasDrawing, true)
//    }
//
//    func test_() {
//        makeSUT()
//        given_thereIsACurrentlyPlayingVideo()
//        given_playerIsAtTime(MediaTime(seconds: 20))
//
//        let testDrawingData = Data()
//        sut.addBookmarkForDrawing(data: testDrawingData)
//
//        XCTAssertEqual(sut.currentBookmarks.first?.drawing, testDrawingData)
//    }
//
//}
//
//// MARK: - MakeSUT and Givens
//
//extension BookmarkListViewModelTests {
//    func makeSUT() {
//        sut = BookmarkListView.ViewModel(playlistPlayer: mockPlaylistPlayer)
//    }
//
//    private func given_thereIsACurrentlyPlayingVideo() {
//        mockPlaylistPlayer.currentlyPlayingVideo = createVideoWithBookmarks([])
//        mockPlaylistPlayer.isPlaying = true
//    }
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
//    private func given_currentlyPlayingVideoHasBookmarkOnLoop(bookmark: Video.Bookmark) {
//        sut.bookmarkOnLoop = bookmark
//    }
//
//    private func createBookmarkWith(note: String?) -> Video.Bookmark {
//        let bookmark = createBookmark(timeIn: MediaTime(seconds: 10), timeOut: MediaTime(seconds: 15))
//        bookmark.note = note
//        return bookmark
//    }
//
//    private func createBookmark(timeIn: MediaTime, timeOut: MediaTime, note: String? = nil) -> Video.Bookmark {
//        Video.Bookmark(id: UUID(), timeIn: timeIn, timeOut: timeOut, note: note)
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
