//
//  UserDefaults+UIColor.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 30/04/2021.
//

import UIKit
import XCTest
@testable import PlaylistPlayer

final class UserDefaults_UIColor: XCTestCase {

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

    func test_colorCanBeSavedAndRetrievedFromUserDefaults() {
        let testColor = UIColor.red

        userDefaults.set(testColor, forKey: testKey)

        let retrievedColor = userDefaults.color(forKey: testKey)
        XCTAssertEqual(testColor, retrievedColor)
    }
}
