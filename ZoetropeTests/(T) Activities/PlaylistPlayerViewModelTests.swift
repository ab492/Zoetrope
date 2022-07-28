//
//  PlaylistPlayerViewModelTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 16/07/2022.
//

import XCTest
@testable import Zoetrope

final class PlaylistPlayerViewModelTests: BaseTestCase {
    
    var mockPlaylistPlayer: PlaylistPlayer!
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
    
    // MARK: - Show Controls Time Preference

    func test_gettingShowControlsTime_returnsUserPeferences() {
        Current.mockUserPreferencesManager.showControlsTime = 10
        
        sut.showControlsTime.verify(equals: .ten)
    }
    
    func test_settingShowControlsTime_updatesUserPreferences() throws {
        sut.showControlsTime = .five
        
        try Current.mockUserPreferencesManager.lastUpdatedShowControlsTime.assertUnwrap().verify(equals: 5)
    }
}
