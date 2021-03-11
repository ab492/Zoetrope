//
//  UserPreferencesTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/03/2021.
//

import XCTest
@testable import PlaylistPlayer

final class UserPreferencesTests: XCTestCase {

    // MARK: - Properties and Setup

    private let testKey = "testKey"
    private let userDefaultsSuiteName = "TestDefaults"
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()

        // Make sure we're working with empty user defaults.
        userDefaults = UserDefaults(suiteName: userDefaultsSuiteName)
        userDefaults.removePersistentDomain(forName: userDefaultsSuiteName)
    }

    // MARK: - Tests

    func test_settingAndRetrievingInt() {
        let sut = makeSUT()

        sut.set(3, forKey: testKey)

        XCTAssertEqual(sut.integer(forKey: testKey), 3)
    }

    func test_NilIsReturnedWhenNoValueForKey() {
        let sut = makeSUT()

        XCTAssertEqual(sut.integer(forKey: testKey), nil)
    }

    func test_RegisteringDefaultInt() {
        let sut = makeSUT()

        sut.register(defaults: [testKey: 3])

        XCTAssertEqual(sut.integer(forKey: testKey), 3)
    }

    // MARK: - SUT

    private func makeSUT() -> UserPreferencesImpl {
        UserPreferencesImpl(userDefaults: userDefaults)
    }
}
