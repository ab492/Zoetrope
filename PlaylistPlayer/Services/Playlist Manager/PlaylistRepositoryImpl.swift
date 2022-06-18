//
//  PlaylistManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation
import UIKit

protocol PlaylistManagerObserver: AnyObject {
    func playlistManagerDidUpdate()
}

protocol PlaylistRepository {

    // Playlists
    var playlists: [Playlist] { get }
    func addPlaylist(_ playlist: Playlist)
    func movePlaylist(from source: IndexSet, to destination: Int)
    func delete(playlistsAt indexSet: IndexSet)

    // Adding Media To Playlist
    func addMediaAt(urls: [URL], to playlist: Playlist)
    func deleteItems(fromPlaylist playlist: Playlist, at offsets: IndexSet)
    func mediaUrlsFor(playlist: Playlist) -> [URL]

    func save()

    // Observable
    var observations: [ObjectIdentifier: WeakBox<PlaylistManagerObserver>] { get set }
    func addObserver(_ observer: PlaylistManagerObserver)
    func removeObserver(_ observer: PlaylistManagerObserver)
}

class PlaylistRepositoryImpl: PlaylistRepository {

    private var playlistStore: PlaylistStore
    private var videoMetadataService: VideoMetadataService

    private(set) var playlists: [Playlist]

    init(playlistStore: PlaylistStore, videoModelBuilder: VideoMetadataService, notificationCenter: NotificationCenter) {
        self.playlistStore = playlistStore
        self.playlists = playlistStore.fetchPlaylists()
        self.videoMetadataService = videoModelBuilder

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationWillResignActive),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)

        DispatchQueue.main.async {
            Current.thumbnailService.addObserver(self)
        }
    }

    convenience init() {
        self.init(playlistStore: PlaylistStoreImpl(),
                  videoModelBuilder: VideoMetadataServiceImpl(),
                  notificationCenter: NotificationCenter.default)
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
        // TODO: Remove metadata of images here!
        playlists.remove(atOffsets: indexSet)
        playlistManagerDidUpdate()
        save()
    }

    func addMediaAt(urls: [URL], to playlist: Playlist) {
        for url in urls {
            videoMetadataService.generateVideoWithMetadataForItemAt(securityScopedURL: url) { video in
                guard let video = video else { return }
                playlist.videos.append(video)
                print("CALLED: \(video.url)")
                self.playlistManagerDidUpdate()
            }
        }
    }

    func deleteItems(fromPlaylist playlist: Playlist, at offsets: IndexSet) {
        for index in offsets {
            // Clear up all store metadata first.
            videoMetadataService.removeMetadata(for: playlist.videos[index])
        }
        playlist.videos.remove(atOffsets: offsets)
        playlistManagerDidUpdate()
        save()
    }

    func mediaUrlsFor(playlist: Playlist) -> [URL] {
        let urls = playlist.videos.map { $0.url }
        print("URLS: \(urls)")
        return urls
    }

    // MARK: - Private

    @objc private func applicationWillResignActive() {
        // If you switch to use scenes, `applicationWillResignActive` isn't called.
        let allVideos = playlists.map { $0.videos }.flatMap { $0 }
        videoMetadataService.cleanupStore(currentVideos: allVideos)
    }

    func save() {
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

extension PlaylistRepositoryImpl: ThumbnailServiceObserver {
    func didFinishProcessingThumbnails() {
        save()
    }
}
