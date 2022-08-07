//
//  UserPreferencesManagerTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/03/2021.
//

import UIKit
import XCTest
import VideoQueuePlayer
@testable import Zoetrope

final class UserPreferencesManagerTests: XCTestCase {

    // MARK: - Properties and Setup

    private var mockUserPreferences: MockUserPreferences!

    override func setUp() {
        super.setUp()

        mockUserPreferences = MockUserPreferences()
    }

    // MARK: - Loop Mode

    func test_settingLoopMode_addsValueToPreferences() throws {
        let sut = makeSUT()

        sut.loopMode = .loopCurrent

        try mockUserPreferences.integer(forKey: "loopMode").assertUnwrap().verify(equals: LoopMode.loopCurrent.rawValue)
    }

    func test_loopMode_defaultsToPlayPlaylistOnce() {
        let sut = makeSUT()

        sut.loopMode.verify(equals: .playPlaylistOnce)
    }
    
    // MARK: - Use Controls Timer

    func test_settingUseControlsTimer_addsValueToPreferences() throws {
        let sut = makeSUT()

        sut.useControlsTimer = false

        try mockUserPreferences.bool(forKey: "useControlsTimer").assertUnwrap().verifyFalse()
    }

    func test_useControlsTimer_defaultsToTrue() {
        let sut = makeSUT()

        sut.useControlsTimer.verifyTrue()
    }
    
    // MARK: - Show Controls Time
    
    func test_settingShowControlsTime_addsValueToPreferences() throws {
        let sut = makeSUT()

        sut.showControlsTime = 10

        try mockUserPreferences.integer(forKey: "showControlsTime").assertUnwrap().verify(equals: 10)
    }

    func test_showControlsTime_defaultsTo3() {
        let sut = makeSUT()

        sut.showControlsTime.verify(equals: 3)
    }

    
    // MARK: - Helpers

    @discardableResult private func makeSUT() -> UserPreferencesManagerImpl {
        UserPreferencesManagerImpl(userPreferences: mockUserPreferences)
    }
}
