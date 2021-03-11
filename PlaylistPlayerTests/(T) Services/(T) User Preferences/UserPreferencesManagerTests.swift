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

    func test_settingSortByDurationOrder_addsValueToPreferences() {
        let sut = makeSUT()

        sut.sortByDurationOrder = .descending

        XCTAssertEqual(mockUserPreferences.integer(forKey: "sortByDurationOrder"), SortOrder.descending.rawValue)
    }

    func test_sortByDurationOrder_defaultsToAscending() {
        let sut = makeSUT()

        XCTAssertEqual(sut.sortByDurationOrder, .descending)
    }

    func test_settingSortByTitleOrder_addsValueToPreferences() {
        let sut = makeSUT()

        sut.sortByTitleOrder = .descending

        XCTAssertEqual(mockUserPreferences.integer(forKey: "sortByTitleOrder"), SortOrder.descending.rawValue)
    }

    func test_sortByTitleOrder_defaultsToAscending() {
        let sut = makeSUT()

        XCTAssertEqual(sut.sortByTitleOrder, .descending)
    }

    // MARK: - Helpers

    @discardableResult private func makeSUT() -> UserPreferencesManagerImpl {
        UserPreferencesManagerImpl(userPreferences: mockUserPreferences)
    }
}
