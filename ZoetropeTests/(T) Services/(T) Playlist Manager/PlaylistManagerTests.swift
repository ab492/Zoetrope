////
////  PlaylistManagerTests.swift
////  PlaylistPlayerTests
////
////  Created by Andy Brown on 10/02/2021.
////
//
// import XCTest
// @testable import Zoetrope
//
// class PlaylistManagerTests: XCTestCase {
//
//    private var mockPlaylistStore: MockPlaylistStore!
//    private var mockMediaMetadataService: MockVideoMetadataService!
//    private var notificationCenter: NotificationCenter!
//
//    override func setUp() {
//        super.setUp()
//        
//        mockPlaylistStore = MockPlaylistStore()
//        mockMediaMetadataService = MockVideoMetadataService()
//        notificationCenter = NotificationCenter()
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
//    func test_addingNewPlaylist_appendsToPreviousPlaylists() {
//        var playlists = testPlaylists(3)
//        given_playlistStoreReturnsPlaylists(playlists)
//
//        let sut = makeSUT()
//        let playlistToAdd = PlaylistBuilder().build()
//        sut.addPlaylist(playlistToAdd)
//
//        let expected = playlists + [playlistToAdd]
//        XCTAssertEqual(sut.playlists, expected)
//    }
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
//        given_playlistStoreReturnsPlaylists([playlist])
//        given_videoMetadataServiceSuccessfullyCreatesMetadata()
//        let sut = makeSUT()
//
//        sut.addMediaAt(urls: [makeTemporaryFilePathForTest()], to: playlist)
//
//        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
//    }
//
//    // MARK: - Application Will Resign Active
//
//    func test_applicationWillResignActive_setsCleanupOnStore() {
//        makeSUT()
//
//        when_applicationWillResignActive()
//
//        XCTAssertEqual(mockMediaMetadataService.cleanupStoreCount, 1)
//    }
// }
//
// extension PlaylistManagerTests {
//    @discardableResult private func makeSUT() -> PlaylistManagerImpl {
//        PlaylistManagerImpl(playlistStore: mockPlaylistStore, videoModelBuilder: mockMediaMetadataService, notificationCenter: notificationCenter)
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
//
//    private func given_videoMetadataServiceSuccessfullyCreatesMetadata() {
//        let video = VideoBuilder().build()
//        mockMediaMetadataService.generateVideoBehavior = .success(video)
//    }
//
//    private func when_applicationWillResignActive() {
//        notificationCenter.post(name: UIApplication.willResignActiveNotification, object: nil)
//    }
// }
