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
    var overlayNotes: Bool { get set }
    var noteColor: UIColor { get set }
}

final class UserPreferencesManagerImpl: UserPreferencesManager {

    // MARK: - Types

    struct Keys {
        static let loopMode = "loopMode"
        static let overlayNotes = "overlayNotes"
        static let noteColor = "noteColor"
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

    var overlayNotes: Bool {
        get {
            return userPreferences.bool(forKey: Keys.overlayNotes) ?? false
        }
        set {
            userPreferences.set(newValue, forKey: Keys.overlayNotes)
        }
    }

    var noteColor: UIColor {
        get {
            return userPreferences.color(forKey: Keys.noteColor) ?? .white
        }
        set {
            userPreferences.set(newValue, forKey: Keys.noteColor)
        }
    }
}
