//
//  PlaylistSiderbarViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 05/03/2021.
//

import Foundation

extension PlaylistSidebarView {

    class ViewModel: ObservableObject {

        // MARK: - Init

        init() {
            DispatchQueue.main.async {
                Current.playlistManager.addObserver(self)
            }
        }

        // MARK: - Public

        var playlistCount: String {
            switch Current.playlistManager.playlists.count {
            case 1:
                return "1 playlist"
            default:
                return "\(Current.playlistManager.playlists.count) playlists"
            }
        }

        var playlistStoreIsEmpty: Bool {
            Current.playlistManager.playlists.isEmpty
        }

        var playlists: [Playlist] {
            Current.playlistManager.playlists
        }

        func addPlaylist(_ title: String) {
            Current.playlistManager.addPlaylist(Playlist(name: title))
        }

        func movePlaylist(from source: IndexSet, to destination: Int) {
            Current.playlistManager.movePlaylist(from: source, to: destination)
        }

        func removePlaylists(at offsets: IndexSet) {
            Current.playlistManager.delete(playlistsAt: offsets)
        }

    }
}

extension PlaylistSidebarView.ViewModel: PlaylistManagerObserver {
    func playlistManagerDidUpdate() {
        objectWillChange.send()
    }
}
