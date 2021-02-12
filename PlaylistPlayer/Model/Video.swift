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

    init(id: UUID = UUID(), filename: String) {
        self.id = id
        self.filename = filename
    }
}

extension Video: Equatable {
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id && lhs.filename == rhs.filename
    }
}
