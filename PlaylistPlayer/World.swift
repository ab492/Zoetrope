//
//  World.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

var Current = World(dateTimeService: DateTimeServiceImpl(),
                    featureFlags: FeatureFlags(),
                    playlistManager: PlaylistManagerImpl(),
                    playlistPlayer: PlaylistPlayerImpl(),
                    thumbnailService: ThumbnailServiceImpl(),
                    userPreferencesManager: UserPreferencesManagerImpl())

struct World {
    var dateTimeService: DateTimeService
    var featureFlags: FeatureFlags
    var playlistManager: PlaylistManager
    var playlistPlayer: PlaylistPlayer
    var thumbnailService: ThumbnailService
    var userPreferencesManager: UserPreferencesManager
}
