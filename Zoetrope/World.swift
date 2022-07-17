//
//  World.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

var Current: World!

struct World {
    var dateTimeService: DateTimeService
    var playlistManager: PlaylistRepository
    var playlistPlayer: PlaylistPlayer
    var thumbnailService: ThumbnailService
    var userPreferencesManager: UserPreferencesManager
    
    var allAppServices: [AppService] {
        Mirror(reflecting: self).children.compactMap { $0.value as? AppService }
    }
}
