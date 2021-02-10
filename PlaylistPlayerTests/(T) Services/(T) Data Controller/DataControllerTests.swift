//
//  DataControllerTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 06/02/2021.
//

import XCTest
@testable import PlaylistPlayer

final class DataControllerTests: XCTestCase {

    private var mockPlaylistStore: MockPlaylistStore!

    override func setUp() {
        super.setUp()

        mockPlaylistStore = MockPlaylistStore()
    }

    func test_ifPlaylistStoreHasItems_theyAreFetchedOnInitOfDataController() {
        let playlists = testPlaylists(3)
        given_playlistStoreReturnsPlaylists(playlists)

        let sut = makeSUT()

        XCTAssertEqual(sut.playlists, playlists)
    }

    // MARK: - Adding Playlists

    func test_addingPlaylist_addsPlaylist() {
        let sut = makeSUT()
        let playlist = PlaylistBuilder().name("Test Playlist 1").build()

        sut.addPlaylist(playlist)

        XCTAssertEqual(sut.playlists.count, 1)
        XCTAssertEqual(sut.playlists[0], playlist)
    }

    func test_addingPlaylist_callsSaveOnPlaylistStore() {
        let sut = makeSUT()
        let playlist = PlaylistBuilder().name("Test Playlist 1").build()

        sut.addPlaylist(playlist)

        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
        XCTAssertEqual(mockPlaylistStore.lastSavedPlaylists, [playlist])
    }
    
// TODO: Fix this one!
//    func test_addingNewPlaylist_appendsToPreviousPlaylists() {
//        var playlists = testPlaylists(3)
//        given_playlistStoreReturnsPlaylists(playlists)
//
//        let sut = makeSUT()
//        let playlistToAdd = PlaylistBuilder().build()
//        sut.addPlaylist(playlistToAdd)
//
//        let expected = playlists.append(playlistToAdd)
//        XCTAssertEqual(sut.playlists, expectedPlaylists)
//    }

    // MARK: - Deleting Playlists

    func test_deletingPlaylistAtIndex_deletesPlaylist() {
        let playlists = testPlaylists(3)
        given_playlistStoreReturnsPlaylists(playlists)

        let sut = makeSUT()
        sut.delete(playlistsAt: IndexSet(integer: 1))

        XCTAssertEqual(sut.playlists, [playlists[0], playlists[2]])
    }

    func test_deletingPlaylist_callsSaveOnPlaylistStore() {
        let playlists = testPlaylists(3)
        given_playlistStoreReturnsPlaylists(playlists)

        let sut = makeSUT()
        sut.delete(playlistsAt: IndexSet(integer: 1))

        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
        XCTAssertEqual(mockPlaylistStore.lastSavedPlaylists, [playlists[0], playlists[2]])
    }

    // MARK: - Moving Playlists

    func test_movingPlaylist_movesPlaylist() {
        let playlists = testPlaylists(3)
        given_playlistStoreReturnsPlaylists(playlists)

        let sut = makeSUT()
        sut.movePlaylist(from: IndexSet(integer: 0), to: 2)

        XCTAssertEqual(sut.playlists, [playlists[1], playlists[0], playlists[2]])
    }

    func test_movingPlaylist_callsSJaveOnPlaylistStore() {
        let playlists = testPlaylists(3)
        given_playlistStoreReturnsPlaylists(playlists)

        let sut = makeSUT()
        sut.movePlaylist(from: IndexSet(integer: 0), to: 2)

        XCTAssertEqual(mockPlaylistStore.saveCallCount, 1)
        XCTAssertEqual(mockPlaylistStore.lastSavedPlaylists, [playlists[1], playlists[0], playlists[2]])
    }

    // TODO: Add tests for adding media to playlist.

}

extension DataControllerTests {
    private func makeSUT() -> DataController {
        DataController(playlistStore: mockPlaylistStore)
    }

    private func testPlaylists(_ count: Int) -> [Playlist] {
        var playlists = [Playlist]()
        (0..<count).forEach { _ in
            playlists.append(PlaylistBuilder().build())
        }
        return playlists
    }

    private func given_playlistStoreReturnsPlaylists(_ playlists: [Playlist]) {
        mockPlaylistStore.playlistsToFetch = playlists
    }
}

