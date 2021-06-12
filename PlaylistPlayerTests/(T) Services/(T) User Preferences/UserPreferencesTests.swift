//
//  UserPreferencesTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/03/2021.
//

import UIKit
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

    // MARK: - Int

    func test_settingAndRetrievingInt() {
        let sut = makeSUT()

        sut.set(3, forKey: testKey)

        XCTAssertEqual(sut.integer(forKey: testKey), 3)
    }

    func test_NilIsReturnedWhenNoIntValueForKey() {
        let sut = makeSUT()

        XCTAssertEqual(sut.integer(forKey: testKey), nil)
    }

    func test_RegisteringDefaultInt() {
        let sut = makeSUT()

        sut.register(defaults: [testKey: 3])

        XCTAssertEqual(sut.integer(forKey: testKey), 3)
    }

    // MARK: - Bool

    func test_settingAndRetrievingBool() {
        let sut = makeSUT()

        sut.set(true, forKey: testKey)

        XCTAssertEqual(sut.bool(forKey: testKey), true)
    }

    func test_NilIsReturnedWhenNoBoolValueForKey() {
        let sut = makeSUT()

        XCTAssertEqual(sut.bool(forKey: testKey), nil)
    }

    func test_RegisteringDefaultBool() {
        let sut = makeSUT()

        sut.register(defaults: [testKey: true])

        XCTAssertEqual(sut.bool(forKey: testKey), true)
    }

    // MARK: - String

    func test_settingAndRetrievingString() {
        let sut = makeSUT()

        sut.set("Test string", forKey: testKey)

        XCTAssertEqual(sut.string(forKey: testKey), "Test string")
    }

    func test_NilIsReturnedWhenNoStringValueForKey() {
        let sut = makeSUT()

        XCTAssertEqual(sut.string(forKey: testKey), nil)
    }

    func test_RegisteringDefaultString() {
        let sut = makeSUT()

        sut.register(defaults: [testKey: "Test string"])

        XCTAssertEqual(sut.string(forKey: testKey), "Test string")
    }

    // MARK: - UIColor

    func test_settingAndRetrievingColor() {
        let sut = makeSUT()

        let testColor = UIColor.systemPink
        sut.set(testColor, forKey: testKey)

        XCTAssertEqual(sut.color(forKey: testKey), testColor)
    }

    func test_NilIsReturnedWhenNoColorValueForKey() {
        let sut = makeSUT()

        XCTAssertEqual(sut.color(forKey: testKey), nil)
    }

    // MARK: - SUT

    private func makeSUT() -> UserPreferencesImpl {
        UserPreferencesImpl(userDefaults: userDefaults)
    }
}
