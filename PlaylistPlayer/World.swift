//
//  World.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

var Current = World(date: { Date() },
                    playlistManager: PlaylistManagerImpl(),
                    thumbnailService: ThumbnailServiceImpl(),
                    userPreferencesManager: UserPreferencesManagerImpl())

struct World {
    var date: () -> Date
    var playlistManager: PlaylistManager
    var thumbnailService: ThumbnailService
    var userPreferencesManager: UserPreferencesManager
}
