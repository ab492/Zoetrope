//
//  UserPreferencesManagerTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/03/2021.
//

import UIKit
import XCTest
import VideoQueuePlayer
@testable import PlaylistPlayer

final class UserPreferencesManagerTests: XCTestCase {

    // MARK: - Properties and Setup

    private var mockUserPreferences: MockUserPreferences!

    override func setUp() {
        super.setUp()

        mockUserPreferences = MockUserPreferences()
    }

    // MARK: - Loop Mode

    func test_settingLoopMode_addsValueToPreferences() {
        let sut = makeSUT()

        sut.loopMode = .loopCurrent

        XCTAssertEqual(mockUserPreferences.integer(forKey: "loopMode"), LoopMode.loopCurrent.rawValue)
    }

    func test_loopMode_defaultsToPlayPlaylistOnce() {
        let sut = makeSUT()

        XCTAssertEqual(sut.loopMode, .playPlaylistOnce)
    }

    // MARK: - Overlay Note

    func test_settingOverlayNotes_addsValueToPreferences() {
        let sut = makeSUT()

        sut.overlayNotes = true

        XCTAssertEqual(mockUserPreferences.bool(forKey: "overlayNotes"), true)
    }

    func test_noteOverlay_defaultsToFalse() {
        let sut = makeSUT()

        XCTAssertEqual(sut.overlayNotes, false)
    }

    // MARK: - Note Color

    func test_settingNoteColor_addsValueToPreferences() {
        let sut = makeSUT()

        sut.noteColor = UIColor.green

        XCTAssertEqual(mockUserPreferences.color(forKey: "noteColor"), UIColor.green)
    }

    func test_noteColor_defaultsToWhite() {
        let sut = makeSUT()

        XCTAssertEqual(sut.noteColor, .white)
    }

    // MARK: - Helpers

    @discardableResult private func makeSUT() -> UserPreferencesManagerImpl {
        UserPreferencesManagerImpl(userPreferences: mockUserPreferences)
    }
}
