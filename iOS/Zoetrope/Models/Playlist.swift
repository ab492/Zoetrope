//
//  Playlist.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import Foundation

final class Playlist: Identifiable, Codable {

    let id: UUID
    var name: String
    var videos: [VideoModel]

    init(id: UUID = UUID(), name: String, videos: [VideoModel] = []) {
        self.id = id
        self.name = name
        self.videos = videos
    }

    // MARK: - Codable

    enum CodingKeys: CodingKey {
        case id, name, videos
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        videos = try container.decode([VideoModel].self, forKey: .videos)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(videos, forKey: .videos)
    }
}

extension Playlist: Equatable {
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.videos == rhs.videos
    }
}

extension Playlist: Hashable {
    // TODO: Is this fair game?
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
