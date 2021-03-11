//
//  MockUserPreferences.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/03/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockUserPreferences: UserPreferences {

    var keyValueStore = [String: Any]()

    func set(_ value: Int, forKey key: String) {
        keyValueStore[key] = value
    }

    func integer(forKey key: String) -> Int? {
        keyValueStore[key] as? Int
    }

    var registeredDefaults: [String: Any]?
    func register(defaults: [String: Any]) {
        registeredDefaults = defaults
    }
}
