//
//  WorldConfigurer.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/06/2022.
//

import Foundation

final class WorldConfigurer {
    static func buildWorld() {
        let world = World(accessibilityService: AccessibilityServiceImpl(),
                          dateTimeService: DateTimeServiceImpl(),
                          playlistManager: PlaylistRepositoryImpl(),
                          playlistPlayer: PlaylistPlayerImpl(),
                          thumbnailService: ThumbnailServiceImpl(),
                          userPreferencesManager: UserPreferencesManagerImpl())
        Current = world
        Current.allAppServices.forEach { $0.onAppServicesLoaded() }
    }
}
