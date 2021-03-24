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

    // MARK: - Video Title

    func test_videoTitle_isReportedCorrectly() {
        // Given we have 2 videos queued
        let video1 = VideoBuilder().filename("Test Filename 1").build()
        let video2 = VideoBuilder().filename("Test Filename 2").build()
        let sut = makeSUT_andQueueVideos([video1, video2])

        // When the player is on the second video
        mockPlaylistPlayer.nowPlayingIndex = 1

        // The video title is correct
        XCTAssertEqual(sut.videoTitle, "Test Filename 2")
    }

    func test_whenNoPlaylistHasBeenQueued_titleIsReportedAsEmptyString() {
        let sut = makeSUT()

        XCTAssertEqual(sut.videoTitle, "")
    }

    // MARK: - Helpers

    func makeSUT() -> PlaylistPlayerViewModel {
        PlaylistPlayerViewModel(playlistPlayer: mockPlaylistPlayer)
    }

    func makeSUT_andQueueVideos(_ videos: [Video]) -> PlaylistPlayerViewModel {
        let playlist = PlaylistBuilder().videos(videos).build()

        let sut = makeSUT()
        sut.updateQueue(for: playlist)

        return sut
    }
}
