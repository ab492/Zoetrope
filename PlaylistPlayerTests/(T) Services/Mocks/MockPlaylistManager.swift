//
//  MockPlaylistManager.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 06/03/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockPlaylistManager: PlaylistManager {

    var addObserverCallCount = 0
    func addObserver(_ observer: PlaylistManagerObserver) {
        addObserverCallCount += 1
    }

    var saveCallCount = 0
    func save() {
        saveCallCount += 1
    }

    var playlists: [Playlist] = []

    var mediaUrlsToReturn: [URL]?
    func mediaUrlsFor(playlist: Playlist) -> [URL] {
        mediaUrlsToReturn ?? []
    }

    func addPlaylist(_ playlist: Playlist) {
        fatalError()
    }

    func movePlaylist(from source: IndexSet, to destination: Int) {
        fatalError()

    }

    func delete(playlistsAt indexSet: IndexSet) {
        fatalError()

    }

    func addMediaAt(urls: [URL], to playlist: Playlist) {
        fatalError()

    }

    func deleteItems(fromPlaylist playlist: Playlist, at offsets: IndexSet) {
        fatalError()

    }

    var observations = [ObjectIdentifier: WeakBox<PlaylistManagerObserver>]()

    func removeObserver(_ observer: PlaylistManagerObserver) {
        fatalError()
    }

}
