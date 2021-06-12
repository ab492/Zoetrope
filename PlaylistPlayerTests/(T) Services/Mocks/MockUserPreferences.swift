//
//  MockUserPreferences.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/03/2021.
//

import Foundation
import UIKit
@testable import PlaylistPlayer

final class MockUserPreferences: UserPreferences {

    var keyValueStore = [String: Any]()

    func set(_ value: Int, forKey key: String) {
        keyValueStore[key] = value
    }

    func integer(forKey key: String) -> Int? {
        keyValueStore[key] as? Int
    }

    func set(_ value: String, forKey key: String) {
        keyValueStore[key] = value
    }

    func string(forKey key: String) -> String? {
        keyValueStore[key] as? String
    }

    func set(_ value: Bool, forKey key: String) {
        keyValueStore[key] = value
    }

    func bool(forKey key: String) -> Bool? {
        keyValueStore[key] as? Bool
    }

    func set(_ value: UIColor, forKey key: String) {
        keyValueStore[key] = value
    }

    func color(forKey key: String) -> UIColor? {
        keyValueStore[key] as? UIColor
    }

    var registeredDefaults: [String: Any]?
    func register(defaults: [String: Any]) {
        registeredDefaults = defaults
    }
}
