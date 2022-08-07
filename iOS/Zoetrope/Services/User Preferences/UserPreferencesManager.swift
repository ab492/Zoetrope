//
//  UserPreferencesManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/03/2021.
//

import Foundation
import UIKit
import VideoQueuePlayer

protocol UserPreferencesManager {
    var loopMode: LoopMode { get set }
    var useControlsTimer: Bool { get set }
    var showControlsTime: Int { get set }
}

final class UserPreferencesManagerImpl: UserPreferencesManager {

    // MARK: - Types

    private enum Keys: String {
        case loopMode
        case useControlsTimer
        case showControlsTime
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
            if let loopModeRawValue = userPreferences.integer(forKey: Keys.loopMode.rawValue),
               let loopMode = LoopMode(rawValue: loopModeRawValue) {
                return loopMode
            } else {
                return .playPlaylistOnce
            }
        }
        set {
            userPreferences.set(newValue.rawValue, forKey: Keys.loopMode.rawValue)
        }
    }
    
    var useControlsTimer: Bool {
        get {
            return userPreferences.bool(forKey: Keys.useControlsTimer.rawValue) ?? true
        }
        set {
            userPreferences.set(newValue, forKey: Keys.useControlsTimer.rawValue)
        }
    }
    
    var showControlsTime: Int {
        get {
            return userPreferences.integer(forKey: Keys.showControlsTime.rawValue) ?? 3
        } set {
            print("SET NEW VALUE: \(newValue)")
            userPreferences.set(newValue, forKey: Keys.showControlsTime.rawValue)
        }
    }
}
