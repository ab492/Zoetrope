//
//  UserPreferencesManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/03/2021.
//

import Foundation

enum SortOrder: Int {
    case ascending
    case descending

    mutating func toggle() {
        self = self == .ascending ? .descending : .ascending
    }
}

protocol UserPreferencesManager {
    var sortByTitleOrder: SortOrder { get set }
    var sortByDurationOrder: SortOrder { get set }
}

final class UserPreferencesManagerImpl: UserPreferencesManager {

    // MARK: - Types

    struct Keys {
        static let sortByTitleOrder = "sortByTitleOrder"
        static let sortByDurationOrder = "sortByDurationOrder"
    }

    // MARK: - Properties

    private let userPreferences: UserPreferences

    // MARK: - Init

    init(userPreferences: UserPreferences) {
        self.userPreferences = userPreferences
    }

    convenience init() {
        self.init(userPreferences: UserPreferencesImpl())
    }

    // MARK: - Public Getters and Setters
    
    var sortByTitleOrder: SortOrder {
        get {
            if let preferenceRawValue = userPreferences.integer(forKey: Keys.sortByTitleOrder),
               let sortOrder = SortOrder(rawValue: preferenceRawValue) {
                return sortOrder
            } else {
                return .descending
            }
        }
        set {
            userPreferences.set(newValue.rawValue, forKey: Keys.sortByTitleOrder)
        }
    }

    var sortByDurationOrder: SortOrder {
        get {
            if let preferenceRawValue = userPreferences.integer(forKey: Keys.sortByDurationOrder),
               let sortOrder = SortOrder(rawValue: preferenceRawValue) {
                return sortOrder
            } else {
                return .descending
            }
        }
        set {
            userPreferences.set(newValue.rawValue, forKey: Keys.sortByDurationOrder)
        }
    }
}
