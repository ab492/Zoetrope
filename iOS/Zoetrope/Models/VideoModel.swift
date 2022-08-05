//
//  Video.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 01/02/2021.
//

import Foundation

final class VideoModel: Identifiable, Codable {

    // MARK: - Properties

    let id: UUID
    
    let displayName: String

    /// The approximate duration for the video (in seconds, rather that as `MediaTime`).
    let duration: Time
    let filename: String

    var thumbnailFilename: String?
    
    // MARK: - Init

    init(displayName: String, duration: Time, filename: String) {
        self.id = UUID()
        self.displayName = displayName
        self.duration = duration
        self.filename = filename
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case duration
        case thumbnailFilename
        case filename
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        displayName = try values.decode(String.self, forKey: .displayName)
        duration = try values.decode(Time.self, forKey: .duration)
        thumbnailFilename = try? values.decode(String.self, forKey: .thumbnailFilename)
        filename = try values.decode(String.self, forKey: .filename)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(duration, forKey: .duration)
        try container.encode(thumbnailFilename, forKey: .thumbnailFilename)
        try container.encode(filename, forKey: .filename)
    }
}

extension VideoModel: Equatable {
    // TODO: Update this equatable conformance!!
    static func == (lhs: VideoModel, rhs: VideoModel) -> Bool {
        lhs.id == rhs.id && lhs.displayName == rhs.displayName && lhs.thumbnailFilename == rhs.thumbnailFilename
    }
}
