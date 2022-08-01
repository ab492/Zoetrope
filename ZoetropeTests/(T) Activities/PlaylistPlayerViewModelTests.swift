//
//  PlaylistPlayerViewModelTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 16/07/2022.
//

import XCTest
@testable import Zoetrope

final class PlaylistPlayerViewModelTests: BaseTestCase {
    
    var mockPlaylistPlayer: MockPlaylistPlayer!
    var sut: PlaylistPlayerViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockPlaylistPlayer = MockPlaylistPlayer()
        sut = PlaylistPlayerViewModel(playlistPlayer: mockPlaylistPlayer)
    }
    
    // MARK: - Controls Timer Preference

    func test_gettingUseControlsTimer_returnsUserPeferences() {
        Current.mockUserPreferencesManager.useControlsTimer = true
        
        sut.useControlsTimer.verifyTrue()
    }
    
    func test_settingUserControlsTimer_updatesUserPreferences() throws {
        sut.useControlsTimer = false
        
        try Current.mockUserPreferencesManager.lastUpdatedUseControlsTimer.assertUnwrap().verifyFalse()
    }
        
    func test_isVoiceoverEnabled_thenPreferenceIsIgnoredAndUseControlsTimerIsFalse() {
        Current.mockUserPreferencesManager.useControlsTimer = true
        Current.mockAccessibilityService.isVoiceoverEnabledValueToReturn = true
        
        sut.useControlsTimer.verifyFalse()
    }
        
    // MARK: - Show Controls Time Preference

    func test_gettingShowControlsTime_returnsUserPeferences() {
        Current.mockUserPreferencesManager.showControlsTime = 10
        
        sut.showControlsTime.verify(equals: .ten)
    }
    
    func test_settingShowControlsTime_updatesUserPreferences() throws {
        sut.showControlsTime = .five
        
        try Current.mockUserPreferencesManager.lastUpdatedShowControlsTime.assertUnwrap().verify(equals: 5)
    }
    
    // MARK: - Accessibility Skipping - Increment
    
    func test_accessibilityIncremement_whenContentLessThan5Minutes() throws {
        given_playbackDurationIs(time: MediaTime(minute: 2))
        given_currentPositionIs(time: .zero)
        
        sut.accessibilityIncrement()
        
        try mockPlaylistPlayer.lastSeekedToTime.assertUnwrap().verify(equals: MediaTime(seconds: 5))
    }
    
    func test_accessibilityIncremement_whenContentGreaterThan5MinutesButLessThanAnHour() throws {
        given_playbackDurationIs(time: MediaTime(minute: 30))
        given_currentPositionIs(time: .zero)
        
        sut.accessibilityIncrement()
        
        try mockPlaylistPlayer.lastSeekedToTime.assertUnwrap().verify(equals: MediaTime(minute: 5))
    }
    
    func test_accessibilityIncremement_whenContentGreaterThan1Hour() throws {
        given_playbackDurationIs(time: MediaTime(hour: 2))
        given_currentPositionIs(time: .zero)
        
        sut.accessibilityIncrement()
        
        try mockPlaylistPlayer.lastSeekedToTime.assertUnwrap().verify(equals: MediaTime(minute: 10))
    }
    
    func test_accessibilityIncremement_whenNextIncrementWouldBeLongerThanDuration() {
        given_playbackDurationIs(time: MediaTime(minute: 7))
        given_currentPositionIs(time: MediaTime(minute: 5))
        
        sut.accessibilityIncrement()
        
        mockPlaylistPlayer.lastSeekedToTime.verifyNil()
    }
    
    // MARK: - Accessibility Skipping - Decrement
    
    func test_accessibilityDecremement_whenContentLessThan5Minutes() throws {
        given_playbackDurationIs(time: MediaTime(minute: 2))
        given_currentPositionIs(time: MediaTime(minute: 1))
        
        sut.accessibilityDecrement()
        
        try mockPlaylistPlayer.lastSeekedToTime.assertUnwrap().verify(equals: MediaTime(seconds: 55))
    }
    
    func test_accessibilityDecremement_whenContentGreaterThan5MinutesButLessThanAnHour() throws {
        given_playbackDurationIs(time: MediaTime(minute: 30))
        given_currentPositionIs(time: MediaTime(minute: 25))
        
        sut.accessibilityDecrement()
        
        try mockPlaylistPlayer.lastSeekedToTime.assertUnwrap().verify(equals: MediaTime(minute: 20))
    }
    
    func test_accessibilityDecremement_whenContentGreaterThan1Hour() throws {
        given_playbackDurationIs(time: MediaTime(hour: 2))
        given_currentPositionIs(time: MediaTime(minute: 90))
        
        sut.accessibilityDecrement()
        
        try mockPlaylistPlayer.lastSeekedToTime.assertUnwrap().verify(equals: MediaTime(minute: 80))
    }
    
    func test_accessibilityDecremement_whenNextDecrementWouldBeLessThanZero() throws {
        given_playbackDurationIs(time: MediaTime(minute: 7))
        given_currentPositionIs(time: MediaTime(minute: 4))
        
        sut.accessibilityDecrement()
        
        try mockPlaylistPlayer.lastSeekedToTime.assertUnwrap().verify(equals: .zero)
    }
    
    // MARK: - Helpers
    
    private func given_playbackDurationIs(time: MediaTime) {
        sut.playbackDurationDidChange(to: time)
    }
    
    private func given_currentPositionIs(time: MediaTime) {
        sut.playbackPositionDidChange(to: time)
    }
}
