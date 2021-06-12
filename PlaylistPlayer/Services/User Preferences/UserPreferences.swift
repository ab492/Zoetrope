//
//  UserPreferences.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/03/2021.
//

import Foundation
import UIKit

protocol UserPreferences {
    // Int
    func set(_ value: Int, forKey key: String)
    func integer(forKey key: String) -> Int?

    // Bool
    func set(_ value: Bool, forKey key: String)
    func bool(forKey key: String) -> Bool?

    // String
    func set(_ value: String, forKey key: String)
    func string(forKey key: String) -> String?

    // Color
    func set(_ value: UIColor, forKey key: String)
    func color(forKey key: String) -> UIColor?

    // Defaults
    func register(defaults: [String: Any])
}

final class UserPreferencesImpl: UserPreferences {

    // MARK: - Properties and Init

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    convenience init() {
        self.init(userDefaults: UserDefaults.standard)
    }

    // MARK: - Public

    func set(_ value: Int, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }

    func integer(forKey key: String) -> Int? {
        userDefaults.object(forKey: key) as? Int
    }

    // TODO: Test these!
    func set(_ value: Bool, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }

    func bool(forKey key: String) -> Bool? {
        userDefaults.object(forKey: key) as? Bool
    }

    func set(_ value: String, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }

    func string(forKey key: String) -> String? {
        userDefaults.object(forKey: key) as? String
    }

    func set(_ value: UIColor, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func color(forKey key: String) -> UIColor? {
        userDefaults.color(forKey: key)
    }

    func register(defaults: [String: Any]) {
        userDefaults.register(defaults: defaults)
    }
}
