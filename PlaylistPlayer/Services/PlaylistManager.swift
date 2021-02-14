//
//  PlaylistManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

class PlaylistManager: ObservableObject {

    private var playlistStore: PlaylistStore
    private var videoMetadataService: VideoMetadataService

    @Published private(set) var playlists: [Playlist]

    init(playlistStore: PlaylistStore, videoModelBuilder: VideoMetadataService) {
        self.playlistStore = playlistStore
        self.playlists = playlistStore.fetchPlaylists()
        self.videoMetadataService = videoModelBuilder
    }

    convenience init() {
        self.init(playlistStore: PlaylistStoreImpl(),
                  videoModelBuilder: VideoMetadataServiceImpl())
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

    // Need to be security scoped URLS
    func addMediaAt(urls: [URL], to playlist: Playlist) {
        objectWillChange.send()

        for url in urls {
            if let video = videoMetadataService.generateVideoWithMetadataForItemAt(securityScopedURL: url) {
                playlist.videos.append(video)
            }
        }
        save()
    }

    func deleteItems(fromPlaylist playlist: Playlist, at offsets: IndexSet) {
        objectWillChange.send()

        // Clear thumbnails from store first
        offsets.forEach { index in
//            var item = playlist.videos[index]
            videoMetadataService.removeMetadata(for: &playlist.videos[index])
        }
        playlist.videos.remove(atOffsets: offsets)
        save()
    }

    func mediaUrlsFor(playlist: Playlist) -> [URL] {

        let ids = playlist.videos.map { $0.id }
        var urls = [URL]()

        for id in ids {
            if let url = Current.securityScopedBookmarkStore.url(for: id) {
                urls.append(url)
            }
        }
        return urls
    }
    
    // MARK: - Private

    private func save() {
        playlistStore.save(playlists)
    }
    
}
