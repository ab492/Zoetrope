//
//  PlaylistPlayerViewModelTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 11/03/2021.
//

import XCTest
@testable import PlaylistPlayer

class PlaylistPlayerViewModelTests: BaseTestCase {

    var mockPlaylistPlayer: MockPlaylistPlayer!

    override func setUp() {
        super.setUp()

        mockPlaylistPlayer = MockPlaylistPlayer()
    }

    // MARK: - Updating Loop Mode

    func test_init_setsPlayerLoopModeToSameAsUserPreferences() {
        Current.mockUserPreferencesManager.loopMode = .loopCurrent

        let sut = makeSUT()

        XCTAssertEqual(sut.loopMode, .loopCurrent)
    }

    func test_updatingLoopMode_notifiesPlaylistPlayer() {
        let sut = makeSUT()

        sut.loopMode = .loopCurrent

        XCTAssertEqual(mockPlaylistPlayer.lastSelectedLoopMode, .loopCurrent)
    }

    func test_updatingLoopMode_updatesUserPreferences() {
        let sut = makeSUT()

        sut.loopMode = .loopCurrent

        XCTAssertEqual(Current.mockUserPreferencesManager.lastUpdatedLoopMode, .loopCurrent)
    }


    
    func makeSUT() -> PlaylistPlayerViewModel {
        PlaylistPlayerViewModel(playlistPlayer: mockPlaylistPlayer)
    }
}
