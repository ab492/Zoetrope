//
//  PlaylistManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

protocol PlaylistManagerObserver: class {
    func playlistManagerDidUpdate()
}

protocol PlaylistManager {

    // Playlists
    var playlists: [Playlist] { get }
    func addPlaylist(_ playlist: Playlist)
    func movePlaylist(from source: IndexSet, to destination: Int)
    func delete(playlistsAt indexSet: IndexSet)

    // Adding Media To Playlist
    func addMediaAt(urls: [URL], to playlist: Playlist)
    func deleteItems(fromPlaylist playlist: Playlist, at offsets: IndexSet)
    func mediaUrlsFor(playlist: Playlist) -> [URL]

    // Observable
    var observations: [ObjectIdentifier: WeakBox<PlaylistManagerObserver>] { get set }
    func addObserver(_ observer: PlaylistManagerObserver)
    func removeObserver(_ observer: PlaylistManagerObserver)
}

class PlaylistManagerImpl: PlaylistManager {

    private var playlistStore: PlaylistStore
    private var videoMetadataService: VideoMetadataService

    private(set) var playlists: [Playlist]

    init(playlistStore: PlaylistStore, videoModelBuilder: VideoMetadataService) {
        self.playlistStore = playlistStore
        self.playlists = playlistStore.fetchPlaylists()
        self.videoMetadataService = videoModelBuilder

        DispatchQueue.main.async {
            Current.thumbnailService.addObserver(self)
        }
    }

    convenience init() {
        self.init(playlistStore: PlaylistStoreImpl(),
                  videoModelBuilder: VideoMetadataServiceImpl())
    }

    // MARK: - Public

    func addPlaylist(_ playlist: Playlist) {
        playlists.append(playlist)
        playlistManagerDidUpdate()
        save()
    }

    func movePlaylist(from source: IndexSet, to destination: Int) {
        playlists.move(fromOffsets: source, toOffset: destination)
        playlistManagerDidUpdate()
        save()
    }

    func delete(playlistsAt indexSet: IndexSet) {
        playlists.remove(atOffsets: indexSet)
        playlistManagerDidUpdate()
        save()
    }

    func addMediaAt(urls: [URL], to playlist: Playlist) {
//        objectWillChange.send()
        for url in urls {
            videoMetadataService.generateVideoWithMetadataForItemAt(securityScopedURL: url) { video in
                guard let video = video else { return }
//                self.objectWillChange.send()
                playlist.videos.append(video)
                self.playlistManagerDidUpdate()
                self.save()
            }
        }
    }

    func deleteItems(fromPlaylist playlist: Playlist, at offsets: IndexSet) {
//        objectWillChange.send()

        // Clear thumbnails from store first
        offsets.forEach { index in
//            var item = playlist.videos[index]
            videoMetadataService.removeMetadata(for: &playlist.videos[index])
        }
        playlist.videos.remove(atOffsets: offsets)
        playlistManagerDidUpdate()
        save()
    }

    func mediaUrlsFor(playlist: Playlist) -> [URL] {
        playlist.videos.compactMap { videoMetadataService.url(for: $0) }
    }
    
    // MARK: - Private

    private func save() {
        playlistStore.save(playlists)
    }

    // MARK: - Observable

    private func playlistManagerDidUpdate() {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.playlistManagerDidUpdate()
        }
    }

    var observations = [ObjectIdentifier: WeakBox<PlaylistManagerObserver>]()

    func addObserver(_ observer: PlaylistManagerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = WeakBox(observer)
    }

    func removeObserver(_ observer: PlaylistManagerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
    
}

extension PlaylistManagerImpl: ThumbnailServiceObserver {
    func didFinishProcessingThumbnails() {
        print("SAVE CALLED FROM THUMBNAIL SERVICE!!")
        save()
    }

    func processingThumbnailsDidUpdate(thumbnails: [Video]) {
        //
    }
}

