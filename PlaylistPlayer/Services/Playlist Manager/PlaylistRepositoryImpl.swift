//
//  PlaylistManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation
import UIKit
import ABExtensions

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

final class PlaylistRepositoryImpl: PlaylistRepository {

    // MARK: - Properties
    
    private var playlistStore: PlaylistStore
    private let fileManager: FileManagerWrapped
    private let importAssetConstructor: ImportAssetConstructor
    private let operationQueue = OperationQueue()
    private(set) var playlists: [Playlist]
    
    private var videoBaseURL: URL {
        fileManager.documentsDirectory.appendingPathComponent("Videos")
    }

    // MARK: - Init

    init(playlistStore: PlaylistStore,
         notificationCenter: NotificationCenter,
         fileManagerWrapped: FileManagerWrapped) {
        self.playlistStore = playlistStore
        self.playlists = playlistStore.fetchPlaylists()
        self.fileManager = fileManagerWrapped
        self.importAssetConstructor = ImportAssetConstructor()

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationWillResignActive),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
    }

    convenience init() {
        self.init(playlistStore: PlaylistStoreImpl(),
                  notificationCenter: NotificationCenter.default,
                  fileManagerWrapped: FileManagerWrappedImpl())
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
            addFile(at: url, to: playlist)
        }
    }
    
    private func addFile(at url: URL, to playlist: Playlist) {
        try? fileManager.createDirectoryIfRequired(url: videoBaseURL)
        
        // Very important line. Notes about security scope here:
        // https://danieltull.co.uk/blog/2018/09/09/wrapping-urls-security-scoped-resource-methods/
        _ = url.startAccessingSecurityScopedResource()
        let importAsset = importAssetConstructor.assetFor(sourceURL: url)
                
        // Define operations
        let copyFileToLocationOperation = CopyFileToLocationImportOperation(baseURL: videoBaseURL, importAsset: importAsset)
        let createVideoModelOperation = CreateVideoModelImportOperation(importAsset: importAsset)
        
        // Setup dependencies
        createVideoModelOperation.addDependency(copyFileToLocationOperation)
        
        // Start operations
        operationQueue.addOperation(copyFileToLocationOperation)
        operationQueue.addOperation(createVideoModelOperation)
        
        createVideoModelOperation.onVideoModelCreated = { [weak self] video in
            guard let self = self else { return }
            playlist.videos.append(video)
            self.playlistManagerDidUpdate()
            url.stopAccessingSecurityScopedResource()
            Current.thumbnailService.generateThumbnail(for: video, at: self.videoBaseURL.appendingPathComponent(video.filename))
            self.save()
        }
    }

    func deleteItems(fromPlaylist playlist: Playlist, at offsets: IndexSet) {
        for index in offsets {
            // Clear up all store metadata first.
            Current.thumbnailService.removeThumbnail(for: playlist.videos[index])
        }
        playlist.videos.remove(atOffsets: offsets)
        playlistManagerDidUpdate()
        save()
    }
    
    func mediaUrlsFor(playlist: Playlist) -> [URL] {
        // Takes the media filename to: path/to/documentsDirectory/mediaDirectoryName/filename
        playlist.videos.map { URL(fileURLWithPath: $0.filename, relativeTo: videoBaseURL) }
    }

    // MARK: - Private

    @objc private func applicationWillResignActive() {
        // If you switch to use scenes, `applicationWillResignActive` isn't called.
        let allVideos = playlists.map { $0.videos }.flatMap { $0 }
        Current.thumbnailService.cleanupStoreOfAllExcept(requiredVideos: allVideos)
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

// MARK: - ThumbnailServiceObserver

extension PlaylistRepositoryImpl: ThumbnailServiceObserver {
    func didFinishProcessingThumbnails() {
        save()
    }
}

// MARK: - AppService

extension PlaylistRepositoryImpl: AppService {
    func onAppServicesLoaded() {
        Current.thumbnailService.addObserver(self)
    }
}

