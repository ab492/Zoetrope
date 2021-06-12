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
        // TODO: Make this private so noone else can sort it.
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

        var videos: [Video] {
            playlist.videos
        }

        var playlistCount: String {
            playlist.formattedCount
        }

        var playlistTitle: String {
            playlist.name
        }

        func index(of video: Video) -> Int {
            playlist.videos.firstIndex(of: video) ?? 0
        }

        func moveVideo(from: IndexSet, to: Int) {
            objectWillChange.send()
            playlist.videos.move(fromOffsets: from, toOffset: to)
            Current.playlistManager.save()
        }

        var sortByTitleSortOrder: SortOrder = .descending {
            didSet {
                objectWillChange.send()
                switch sortByTitleSortOrder {
                case .ascending:
                    playlist.videos = playlist.videos.sorted(by: \.filename, using: <)
                case .descending:
                    playlist.videos = playlist.videos.sorted(by: \.filename, using: >)
                }
                Current.playlistManager.save()
            }
        }

        var sortByDurationSortOrder: SortOrder = .descending {
            didSet {
                objectWillChange.send()
                switch sortByDurationSortOrder {
                case .ascending:
                    playlist.videos = playlist.videos.sorted(by: \.duration, using: <)
                case .descending:
                    playlist.videos = playlist.videos.sorted(by: \.duration, using: >)
                }
                Current.playlistManager.save()
            }
        }

        var shouldShowSortMenu: Bool {
            playlist.videos.count > 0
        }

        var shouldShowEditMenu: Bool {
            playlist.videos.count > 0
        }
    }
}

// MARK: - PlaylistManagerObserver

extension PlaylistDetailView.ViewModel: PlaylistManagerObserver {
    func playlistManagerDidUpdate() {
        objectWillChange.send()
    }
}
