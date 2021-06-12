

//class BookmarkEditorViewModelTests: BaseTestCase {
//
//    var mockPlaylistPlayer: MockPlaylistPlayerViewModel!
//
//    override func setUp() {
//        super.setUp()
//
//        mockPlaylistPlayer = MockPlaylistPlayerViewModel()
//    }
//

//
//func test_nextBookmark_isReportedCorrectly_ifSkippingFromCurrentBookmark() {
//    let bookmark1 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 30))
//    let bookmark2 = createBookmark(timeIn: MediaTime(seconds: 20), timeOut: MediaTime(seconds: 21))
//    let bookmark3 = createBookmark(timeIn: MediaTime(seconds: 30), timeOut: MediaTime(seconds: 40))
//    let bookmark4 = createBookmark(timeIn: MediaTime(seconds: 40), timeOut: MediaTime(seconds: 50))
//    given_currentlyPlayingVideoHasBookmarks([bookmark1, bookmark2, bookmark3, bookmark4])
//    given_playerIsAtTime(MediaTime(seconds: 21))
//
//    let sut = makeSUT()
//    sut.nextBookmark()
//
//    XCTAssertEqual(mockPlaylistPlayer.lastSeekedToTime, bookmark3.timeIn)
//}

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
