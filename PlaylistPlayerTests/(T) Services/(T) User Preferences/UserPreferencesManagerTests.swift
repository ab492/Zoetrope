//
//  UserPreferencesManagerTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/03/2021.
//

import XCTest
@testable import PlaylistPlayer

final class UserPreferencesManagerTests: XCTestCase {

    // MARK: - Properties and Setup

    private var mockUserPreferences: MockUserPreferences!

    override func setUp() {
        super.setUp()

        mockUserPreferences = MockUserPreferences()
    }

    // MARK: - Tests

    func test_settingLoopMode_addsValueToPreferences() {
        let sut = makeSUT()

        sut.loopMode = .loopCurrent

        XCTAssertEqual(mockUserPreferences.integer(forKey: "loopMode"), LoopMode.loopCurrent.rawValue)
    }

    func test_loopMode_defaultsToPlayPlaylistOnce() {
        let sut = makeSUT()

        XCTAssertEqual(sut.loopMode, .playPlaylistOnce)
    }

    // MARK: - Helpers

    @discardableResult private func makeSUT() -> UserPreferencesManagerImpl {
        UserPreferencesManagerImpl(userPreferences: mockUserPreferences)
    }
}
