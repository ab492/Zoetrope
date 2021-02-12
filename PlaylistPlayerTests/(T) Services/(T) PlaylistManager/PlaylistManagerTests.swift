////
////  PlaylistManagerTests.swift
////  PlaylistPlayerTests
////
////  Created by Andy Brown on 10/02/2021.
////
//
//import XCTest
//@testable import PlaylistPlayer
//
//class PlaylistManagerTests: XCTestCase {
//
//    private var mockPlaylistStore: MockPlaylistStore!
//    private var mockMediaStore: MockMediaStore!
//
//    override func setUp() {
//        super.setUp()
//        
//        mockPlaylistStore = MockPlaylistStore()
//        mockMediaStore = MockMediaStore()
//    }
//
//    func test_ifPlaylistStoreHasItems_theyAreFetchedOnInitOfPlaylistManager() {
//        let playlists = testPlaylists(3)
//        given_playlistStoreReturnsPlaylists(playlists)
//
//        let sut = makeSUT()
//
//        XCTAssertEqual(sut.playlists, playlists)
//    }
//
//    // MARK: - Adding Playlists
//
//    func test_addingPlaylist_addsPlaylist() {
//        let sut = makeSUT()
//        let playlist = PlaylistBuilder().name("Test Playlist 1").build()
//
//        sut.addPlaylist(playlist)
//
//        XCTAssertEqual(sut.playlists.count, 1)
//        XCTAssertEqual(sut.playlists[0], playlist)
//    }
//
//    func test_addingPlaylist_callsSaveOnPlaylistStore() {
//        let sut = makeSUT()
//        let playlist = PlaylistBuilder().name("Test Playlist 1").build()
//
//        sut.addPlaylist(playlist)
//
//        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
//        XCTAssertEqual(mockPlaylistStore.lastSavedPlaylists, [playlist])
//    }
//
//    //     TODO: Fix this one!
////    func test_addingNewPlaylist_appendsToPreviousPlaylists() {
////        var playlists = testPlaylists(3)
////        given_playlistStoreReturnsPlaylists(playlists)
////
////        let sut = makeSUT()
////        let playlistToAdd = PlaylistBuilder().build()
////        sut.addPlaylist(playlistToAdd)
////
////        let expected = playlists.append(playlistToAdd)
////        XCTAssertEqual(sut.playlists, expected)
////    }
//
//    // MARK: - Deleting Playlists
//
//    func test_deletingPlaylistAtIndex_deletesPlaylist() {
//        let playlists = testPlaylists(3)
//        given_playlistStoreReturnsPlaylists(playlists)
//
//        let sut = makeSUT()
//        sut.delete(playlistsAt: IndexSet(integer: 1))
//
//        XCTAssertEqual(sut.playlists, [playlists[0], playlists[2]])
//    }
//
//    func test_deletingPlaylist_callsSaveOnPlaylistStore() {
//        let playlists = testPlaylists(3)
//        given_playlistStoreReturnsPlaylists(playlists)
//
//        let sut = makeSUT()
//        sut.delete(playlistsAt: IndexSet(integer: 1))
//
//        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
//        XCTAssertEqual(mockPlaylistStore.lastSavedPlaylists, [playlists[0], playlists[2]])
//    }
//
//    // MARK: - Moving Playlists
//
//    func test_movingPlaylist_movesPlaylist() {
//        let playlists = testPlaylists(3)
//        given_playlistStoreReturnsPlaylists(playlists)
//
//        let sut = makeSUT()
//        sut.movePlaylist(from: IndexSet(integer: 0), to: 2)
//
//        XCTAssertEqual(sut.playlists, [playlists[1], playlists[0], playlists[2]])
//    }
//
//    func test_movingPlaylist_callsSaveOnPlaylistStore() {
//        let playlists = testPlaylists(3)
//        given_playlistStoreReturnsPlaylists(playlists)
//
//        let sut = makeSUT()
//        sut.movePlaylist(from: IndexSet(integer: 0), to: 2)
//
//        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
//        XCTAssertEqual(mockPlaylistStore.lastSavedPlaylists, [playlists[1], playlists[0], playlists[2]])
//    }
//
//    // MARK: - Adding Media
//
//    func test_addingMediaToPlaylist_callsSaveOnPlaylistStore() {
//        let playlist = PlaylistBuilder().build()
//        mockPlaylistStore.playlistsToFetch = [playlist]
//        let sut = makeSUT()
//
//        let testURL = makeTemporaryFilePathForTest()
//        sut.addMediaAt(urls: [testURL], to: playlist)
//
//        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
//    }
//
//    func test_addingMediaToPlaylist_addsMediaToStoreAndCorrectlyBuildsVideo() {
//        let playlist = PlaylistBuilder().build()
//        mockPlaylistStore.playlistsToFetch = [playlist]
//        mockMediaStore.relativePathToReturnFromCopy = "test/relative/path/test_media.mov"
//        let sut = makeSUT()
//
//        let testURL = makeTemporaryFilePathForTest()
//        sut.addMediaAt(urls: [testURL], to: playlist)
//
//        // TODO: Tidy this up
//        XCTAssertEqual(sut.playlists.first!.videos.first!.relativeFilepath, "test/relative/path/test_media.mov")
//        XCTAssertEqual(sut.playlists.first!.videos.first!.filename, "test_media.mov")
//    }
//
//
//
//}
//
//extension PlaylistManagerTests {
//    private func makeSUT() -> PlaylistManager {
//        PlaylistManager(mediaStore: mockMediaStore, playlistStore: mockPlaylistStore)
//    }
//
//    private func testPlaylists(_ count: Int) -> [Playlist] {
//        var playlists = [Playlist]()
//        (0..<count).forEach { _ in
//            playlists.append(PlaylistBuilder().build())
//        }
//        return playlists
//    }
//
//    private func makeTemporaryFilePathForTest() -> URL {
//        let path = NSTemporaryDirectory() + UUID().uuidString
//        try? FileManager.default.removeItem(atPath: path)
//        return URL(fileURLWithPath: path)
//    }
//
//    private func given_playlistStoreReturnsPlaylists(_ playlists: [Playlist]) {
//        mockPlaylistStore.playlistsToFetch = playlists
//    }
//}
