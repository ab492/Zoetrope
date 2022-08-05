//
//  TestPlaylistPlayerObserver.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 27/03/2021.
//

import Foundation
@testable import Zoetrope

class TestPlaylistPlayerObserver: PlaylistPlayerObserver {

    var lastReportedPlaybackState: PlayPauseState?
    func playbackStateDidChange(to playPauseState: PlayPauseState) {
        lastReportedPlaybackState = playPauseState
    }

    var lastReportedPlaybackReadiness: Bool?
    func playbackReadinessDidChange(isReady: Bool) {
        lastReportedPlaybackReadiness = isReady
    }

    var lastReportedFastReverseAbility: Bool?
    func playbackFastReverseAbilityDidChange(canPlayFastReverse: Bool) {
        lastReportedFastReverseAbility = canPlayFastReverse
    }

    var lastReportedFastForwardAbility: Bool?
    func playbackFastForwardAbilityDidChange(canPlayFastForward: Bool) {
        lastReportedFastForwardAbility = canPlayFastForward
    }

    var lastReportedPlaybackPosition: MediaTime?
    func playbackPositionDidChange(to time: MediaTime) {
        lastReportedPlaybackPosition = time
    }

    var playbackDurationDidChangeCallCount = 0
    func playbackDurationDidChange(to time: MediaTime) {
        playbackDurationDidChangeCallCount += 1
    }

    var lastUpdatedLoopMode: LoopMode?
    func loopModeDidUpdate(newValue: LoopMode) {
        lastUpdatedLoopMode = newValue
    }
}
