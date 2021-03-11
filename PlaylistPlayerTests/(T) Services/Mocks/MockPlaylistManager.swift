//
//  MockPlaylistManager.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 06/03/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockPlaylistManager: PlaylistManager {
    func save() {
        fatalError()
    }

    var playlists: [Playlist] = []

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

    func mediaUrlsFor(playlist: Playlist) -> [URL] {
        fatalError()

    }

    var observations = [ObjectIdentifier: WeakBox<PlaylistManagerObserver>]()

    func addObserver(_ observer: PlaylistManagerObserver) {
        fatalError()

    }

    func removeObserver(_ observer: PlaylistManagerObserver) {
        fatalError()

    }

}