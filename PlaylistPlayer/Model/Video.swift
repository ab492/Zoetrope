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
    let relativeFilepath: String

    init(id: UUID = UUID(), relativeFilepath: String) {
        self.id = id
        self.filename = relativeFilepath
        self.relativeFilepath = relativeFilepath
    }
}

extension Video: Equatable {
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id && lhs.filename == rhs.filename && lhs.relativeFilepath == rhs.relativeFilepath
    }
}

extension Video: CustomStringConvertible {
    var description: String {
        "ID:\(id), Filename: \(filename), Filepath: \(relativeFilepath)"
    }
}
