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
//    @Published var processingPct: Double

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

    func addMediaAt(urls: [URL], to playlist: Playlist) {
        objectWillChange.send()
        for (index, url) in urls.enumerated() {
            videoMetadataService.generateVideoWithMetadataForItemAt(securityScopedURL: url) { video in
                guard let video = video else { return }
                self.objectWillChange.send()
                playlist.videos.append(video)
                self.save()
            }
        }
    }

    // Need to be security scoped URLS
//    func addMediaAt(urls: [URL], to playlist: Playlist) {
//
//        let totalAmountProcess = Double(urls.count)
//        var remainingToProcess = totalAmountProcess
//        processingPct = 0
//
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let self = self else { return }
//
//            for (index, url) in urls.enumerated() {
//                if let video = self.videoMetadataService.generateVideoWithMetadataForItemAt(securityScopedURL: url) {
//
//                    DispatchQueue.main.async {
//                        playlist.videos.append(video)
//                        remainingToProcess -= 1
//                        self.processingPct = (totalAmountProcess - remainingToProcess) / totalAmountProcess
//
//                        if index == urls.count - 1 {
//                            self.save()
//                            self.processingPct = nil
//                        }
//                    }
//                }
//            }
//        }
//    }

//    func addMediaAt(urls: [URL], to playlist: Playlist) {
//
//        let totalAmountProcess = Double(urls.count)
//        var remainingToProcess = totalAmountProcess
//        processingPct = 0
//
//        for (index, url) in urls.enumerated() {
//            videoMetadataService.generateVideoWithMetadataForItemAt(securityScopedURL: url) { (video) in
//                guard let video = video else { return }
//                playlist.videos.append(video)
//                remainingToProcess -= 1
//                self.processingPct = (totalAmountProcess - remainingToProcess) / totalAmountProcess
//
//                if index == urls.count - 1 {
//                    self.save()
//                    self.processingPct = nil
//                }
//            }
//
//        }
//    }




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

    func save() {
        playlistStore.save(playlists)
    }
    
}
