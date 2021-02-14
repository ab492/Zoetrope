//
//  Video.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 01/02/2021.
//

import Foundation

final class Video: Identifiable, Codable {
    let id: UUID
    let filename: String
    let duration: Time
    var thumbnailFilename: String?

    init(id: UUID = UUID(), filename: String, duration: Time, thumbnailFilename: String? = nil) {
        self.id = id
        self.filename = filename
        self.duration = duration
        self.thumbnailFilename = thumbnailFilename
    }
}

extension Video: Equatable {
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id && lhs.filename == rhs.filename && lhs.thumbnailFilename == rhs.thumbnailFilename
    }
}
