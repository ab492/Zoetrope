//
//  MockPlaylistStore.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 06/02/2021.
//

import Foundation
@testable import Zoetrope

final class MockPlaylistStore: PlaylistStore {

    var lastSavedPlaylists: [Playlist]?
    var saveCallCount = 0
    func save(_ playlists: [Playlist]) {
        lastSavedPlaylists = playlists
        saveCallCount += 1
    }
    
    var playlistsToFetch: [Playlist] = []
    func fetchPlaylists() -> [Playlist] {
        playlistsToFetch
    }

}
