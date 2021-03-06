//
//  PlaylistDetailViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 04/03/2021.
//

import Foundation
import Combine

extension PlaylistDetailView {

    class ViewModel: ObservableObject {

        // MARK: - Properties

        private(set) var playlist: Playlist

        // MARK: - Init

        init(playlist: Playlist) {
            self.playlist = playlist
            Current.playlistManager.addObserver(self)
        }

        // MARK: - Public

        var playlistIsEmpty: Bool {
            playlist.videos.isEmpty
        }

        func addMedia(at urls: [URL]) {
            Current.playlistManager.addMediaAt(urls: urls, to: playlist)
        }

        func removeRows(at offsets: IndexSet) {
            Current.playlistManager.deleteItems(fromPlaylist: playlist, at: offsets)
        }

        func index(of video: Video) -> Int {
            playlist.videos.firstIndex(of: video) ?? 0
        }

    }
}

// MARK: - PlaylistManagerObserver

extension PlaylistDetailView.ViewModel: PlaylistManagerObserver {
    func playlistManagerDidUpdate() {
        objectWillChange.send()
    }
}

