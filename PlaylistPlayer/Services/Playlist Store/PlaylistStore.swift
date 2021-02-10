//
//  StorageController.swift
//  Quickfire
//
//  Created by Andy Brown on 23/12/2020.
//

import Foundation

protocol PlaylistStore {
    func save(_ playlists: [Playlist])
    func fetchPlaylists() -> [Playlist]
}

final class PlaylistStoreImpl: PlaylistStore {

    // MARK: - Properties

    private let location: URL

    // MARK: - Init

    init(location: URL) {
        self.location = location
    }

    convenience init() {
        let defaultLocation = FileManager.default.documentsDirectory
            .appendingPathComponent("Playlists")
            .appendingPathExtension("json")
        self.init(location: defaultLocation)
    }

    // MARK: - Public

    func save(_ playlists: [Playlist]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(playlists) else { return }
        do {
            try data.write(to: location)
        } catch let error {
            print("Error writing playlists to disk: \(error.localizedDescription)")
        }
    }

    func fetchPlaylists() -> [Playlist] {
        guard let data = try? Data(contentsOf: location) else { return [] }
        let decoder = JSONDecoder()
        do {
            let playlists = try decoder.decode([Playlist].self, from: data)
            return playlists
        } catch let error {
            print("Error fetching playlists from disk: \(error.localizedDescription)")
            return []
        }
    }
}
