//
//  PlaylistManager.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

class PlaylistManager: ObservableObject {
    
    private var playlistStore: PlaylistStore
    private var securityScopedBookmarkStore: SecurityScopedBookmarkStore

    @Published private(set) var playlists: [Playlist]

    init(playlistStore: PlaylistStore, securityScopedBookmarkStore: SecurityScopedBookmarkStore) {
        self.playlistStore = playlistStore
        self.securityScopedBookmarkStore = securityScopedBookmarkStore
        self.playlists = playlistStore.fetchPlaylists()
    }

    convenience init() {
        self.init(playlistStore: PlaylistStoreImpl(), securityScopedBookmarkStore: SecurityScopedBookmarkStoreImpl())
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
            let filename = FileManager.default.displayName(atPath: url.path)
            let video = Video(filename: filename)
            
            if let bookmark = SecurityScopedBookmark(id: video.id, securityScopedURL: url) {
                securityScopedBookmarkStore.add(bookmark: bookmark )
            }

            playlist.videos.append(video)
        }
        save()
    }

    func mediaUrlsFor(playlist: Playlist) -> [URL] {

        let ids = playlist.videos.map { $0.id }
        var urls = [URL]()

        for id in ids {
            if let url = securityScopedBookmarkStore.url(for: id) {
                urls.append(url)
            }
        }
        return urls


//        let relativeURLS = playlist.videos.map { $0.relativeFilepath }
//        var urls = [URL]()
//        for relativeURL in relativeURLS {
//            urls.append(mediaStore.urlForItemAt(relativePath: relativeURL))
//        }
//        return urls
    }
    
    // MARK: - Private

    private func save() {
        playlistStore.save(playlists)
    }
    
}
