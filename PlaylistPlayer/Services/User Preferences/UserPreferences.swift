//
//  UserPreferences.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/03/2021.
//

import Foundation

protocol UserPreferences {
    func set(_ value: Int, forKey key: String)
    func integer(forKey key: String) -> Int?
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

    func register(defaults: [String: Any]) {
        userDefaults.register(defaults: defaults)
    }
}
