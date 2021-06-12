//
//  PlaylistPlayerTests-SkipThreshold.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 27/03/2021.
//

import XCTest
@testable import PlaylistPlayer

extension PlaylistPlayerTests {

    // When the user taps previous/next mid-playback, the player reloads the next item
    // which causes the playback controls to flicker. For example, skip next causes the
    // play button to flick to paused while the next item is loaded, and then very
    // quickly it flicks back to playing. These tests verify that we have a small
    // window where state changes aren't reported.
    
    // MARK: - Play Pause State

    func test_playPauseStatusChangeFromSkipNext_isNotReportedIfWithinSkipThreshold() {
        let sut = makeSUT()

        given_playerIsPlaying()
        XCTAssertEqual(sut.isPlaying, true)

        // Simulate user skipping to next
        Current.mockDateTimeService.absoluteTime = 0
        sut.nextItem()

        // Simulate player reloading next item (paused status)
        given_playerReportsPausedPlaybackStateAt(time: 0.1)

        XCTAssertEqual(sut.isPlaying, true)
    }

    func test_playPauseStatusChangeFromSkipPrevious_isNotReportedIfWithinSkipThreshold() {
        let sut = makeSUT()

        given_playerIsPlaying()
        XCTAssertEqual(sut.isPlaying, true)

        // Simulate user skipping to previous
        Current.mockDateTimeService.absoluteTime = 0
        sut.previousItem()

        // Simulate player reloading next item (paused state)
        given_playerReportsPausedPlaybackStateAt(time: 0.1)

        XCTAssertEqual(sut.isPlaying, true)
    }

    func test_playPauseStatusChangeFromSkipNext_isReportedIfOutsideOfSkipThreshold() {
        let sut = makeSUT()

        given_playerIsPlaying()
        XCTAssertEqual(sut.isPlaying, true)

        // Simulate user skipping to next
        Current.mockDateTimeService.absoluteTime = 0
        sut.nextItem()

        // Simulate player reloading next item (paused status)
        given_playerReportsPausedPlaybackStateAt(time: 0.6)

        XCTAssertEqual(sut.isPlaying, false)
    }

    func test_playPauseStatusChangeFromSkipPrevious_isReportedIfOutsideOfSkipThreshold() {
        let sut = makeSUT()

        given_playerIsPlaying()
        XCTAssertEqual(sut.isPlaying, true)

        // Simulate user skipping to previous
        Current.mockDateTimeService.absoluteTime = 0
        sut.previousItem()

        // Simulate player reloading next item (paused state)
        given_playerReportsPausedPlaybackStateAt(time: 0.6)

        XCTAssertEqual(sut.isPlaying, false)
    }
}

// MARK: - Helpers

extension PlaylistPlayerTests {
    private func given_playerIsReadyForPlayback() {
        mockVideoQueuePlayer.observer?.playbackItemStatusDidChange(to: .readyToPlay)
    }

    private func given_playerIsPlaying() {
        mockVideoQueuePlayer.observer?.playbackStateDidChange(to: .playing)
    }

    private func given_playerReportsUnknownStatusAt(time: Double) {
        Current.mockDateTimeService.absoluteTime = time
        mockVideoQueuePlayer.observer?.playbackItemStatusDidChange(to: .unknown)
    }

    private func given_playerReportsPausedPlaybackStateAt(time: Double) {
        Current.mockDateTimeService.absoluteTime = time
        mockVideoQueuePlayer.observer?.playbackStateDidChange(to: .paused)
    }
}






