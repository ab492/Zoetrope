//
//  UserPreferencesManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/03/2021.
//

import Foundation
import UIKit

protocol UserPreferencesManager {
    var loopMode: LoopMode { get set }
}

final class UserPreferencesManagerImpl: UserPreferencesManager {

    // MARK: - Types

    struct Keys {
        static let loopMode = "loopMode"
//        static let overlayNotes = "overlayNotes"
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

    var loopMode: LoopMode {
        get {
            if let loopModeRawValue = userPreferences.integer(forKey: Keys.loopMode),
               let loopMode = LoopMode(rawValue: loopModeRawValue) {
                return loopMode
            } else {
                return .playPlaylistOnce
            }
        }
        set {
            userPreferences.set(newValue.rawValue, forKey: Keys.loopMode)
        }
    }

    // leaving as an example of working with user preferences
//
//    var overlayNotes: Bool {
//        get {
//            return userPreferences.bool(forKey: Keys.overlayNotes) ?? true
//        }
//        set {
//            userPreferences.set(newValue, forKey: Keys.overlayNotes)
//        }
//    }
}
