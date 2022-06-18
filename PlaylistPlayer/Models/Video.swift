//
//  Video.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 01/02/2021.
//

import Foundation

final class Video: Identifiable, Codable {

    // MARK: - Properties

    let id: UUID
    let filename: String

    /// The approximate duration for the video (in seconds, rather that as `MediaTime`).
    let duration: Time
    let underlyingFilename: String

    var thumbnailFilename: String?
    
    // MARK: - Init

    init(id: UUID = UUID(), filename: String, duration: Time, thumbnailFilename: String? = nil, underlyingFilename: String) {
        self.id = id
        self.filename = filename
        self.duration = duration
        self.thumbnailFilename = thumbnailFilename
        self.underlyingFilename = underlyingFilename
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case filename
        case duration
        case thumbnailFilename
        case underlyingFilename
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        filename = try values.decode(String.self, forKey: .filename)
        duration = try values.decode(Time.self, forKey: .duration)
        thumbnailFilename = try? values.decode(String.self, forKey: .thumbnailFilename)
        underlyingFilename = try values.decode(String.self, forKey: .underlyingFilename)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(filename, forKey: .filename)
        try container.encode(duration, forKey: .duration)
        try container.encode(thumbnailFilename, forKey: .thumbnailFilename)
        try container.encode(underlyingFilename, forKey: .underlyingFilename)
    }
}

extension Video: Equatable {
    // TODO: Update this equatable conformance!!
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id && lhs.filename == rhs.filename && lhs.thumbnailFilename == rhs.thumbnailFilename
    }
}
