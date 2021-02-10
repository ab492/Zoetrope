//
//  DataController.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import Foundation

final class DataController: ObservableObject {

    // MARK: - Properties

    private let playlistStore: PlaylistStore
    private let mediaStore = MediaStoreImpl()
    
    @Published var playlists: [Playlist]

    // MARK: - Init

    init(playlistStore: PlaylistStore) {
        self.playlistStore = playlistStore
        self.playlists = playlistStore.fetchPlaylists()
    }

    convenience init() {
        self.init(playlistStore: PlaylistStoreImpl())
    }

    // MARK: - Public

    func addPlaylist(_ playlist: Playlist) {
        playlists.append(playlist)
        save()
    }

    func movePlaylist(from source: IndexSet, to destination: Int) {
        playlists.move(fromOffsets: source, toOffset: destination)
        save()
    }

    func delete(playlistsAt indexSet: IndexSet) {
        playlists.remove(atOffsets: indexSet)
        save()
    }

    // MARK: - Adding and Editing Playlist Content

    func add(urls: [URL], to playlist: Playlist) {
        objectWillChange.send()
        fatalError("Not working yet!")
//        for url in urls {
//            let finalLocation = mediaStore.co(from: url)
//            let video = Video(url: finalLocation)
//            playlist.videos.append(video)
//        }
        save()
    }


    // MARK: - Private

    private func save() {
        playlistStore.save(playlists)
    }




    
}
