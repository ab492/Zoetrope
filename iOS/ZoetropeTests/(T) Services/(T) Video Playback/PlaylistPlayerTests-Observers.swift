//
//  PlaylistPlayer-Observers.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 27/03/2021.
//


import XCTest
import VideoQueuePlayer
@testable import Zoetrope

extension PlaylistPlayerTests {

    // MARK: - Playback State Did Change

    func test_playbackStateToPaused_isReported() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackStateDidChange(to: .paused)

        XCTAssertEqual(testObserver.lastReportedPlaybackState, .paused)
    }

    func test_playbackStateToPlaying_isReported() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackStateDidChange(to: .playing)

        XCTAssertEqual(testObserver.lastReportedPlaybackState, .playing)
    }

    func test_playbackStateToWaitingToPlay_isReportedAsPaused() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackStateDidChange(to: .waitingToPlayAtSpecifiedRate)

        XCTAssertEqual(testObserver.lastReportedPlaybackState, .paused)
    }

    // MARK: - Playback Readiness

    func test_playbackStatusReadyToPlay_isReportedAsFalse() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackItemStatusDidChange(to: .readyToPlay)

        XCTAssertEqual(testObserver.lastReportedPlaybackReadiness, true)
    }

    func test_playbackStatusFailed_isReportedAsFalse() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackItemStatusDidChange(to: .failed(MockVideoQueuePlayer.TestError.playbackError))

        XCTAssertEqual(testObserver.lastReportedPlaybackReadiness, false)
    }

    func test_playbackStatusUnknown_isReportedAsFalse() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackItemStatusDidChange(to: .unknown)

        XCTAssertEqual(testObserver.lastReportedPlaybackReadiness, false)
    }

    // MARK: - Playback Position

    func test_playbackPositionChange_isReported() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackPositionDidChange(to: MediaTime(seconds: 23))

        XCTAssertEqual(testObserver.lastReportedPlaybackPosition, MediaTime(seconds: 23))
    }

    // MARK: - Duration

    func test_itemStatusUpdate_updatesDuration() {
        makeSUT()

        mockVideoQueuePlayer.observer?.playbackItemStatusDidChange(to: .readyToPlay)

        XCTAssertEqual(testObserver.playbackDurationDidChangeCallCount, 1)
    }

    // MARK: - Fast Reverse Ability

    func test_canFastReverseTrue_isReported() {
        makeSUT()

        mockVideoQueuePlayer.observer?.mediaFastReverseAbilityDidChange(to: true)

        XCTAssertEqual(testObserver.lastReportedFastReverseAbility, true)
    }

    func test_canFastReverseFalse_isReported() {
        makeSUT()

        mockVideoQueuePlayer.observer?.mediaFastReverseAbilityDidChange(to: false)

        XCTAssertEqual(testObserver.lastReportedFastReverseAbility, false)
    }

    // MARK: - Fast Forward Ability

    func test_canFastForwardTrue_isReported() {
        makeSUT()

        mockVideoQueuePlayer.observer?.mediaFastForwardAbilityDidChange(to: true)

        XCTAssertEqual(testObserver.lastReportedFastForwardAbility, true)
    }

    func test_canFastForwardFalse_isReported() {
        makeSUT()

        mockVideoQueuePlayer.observer?.mediaFastForwardAbilityDidChange(to: false)

        XCTAssertEqual(testObserver.lastReportedFastForwardAbility, false)
    }

    // MARK: - Loop Mode

    func test_updatingLoopMode_isReported() {
        let sut = makeSUT()

        sut.loopMode = .playPlaylistOnce

        XCTAssertEqual(testObserver.lastUpdatedLoopMode, .playPlaylistOnce)
    }
}
