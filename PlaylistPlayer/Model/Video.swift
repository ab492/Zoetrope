//
//  Video.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 01/02/2021.
//

import Foundation

class Video: Identifiable {
    let id: UUID
    let filename: String
    let url: URL

    init(id: UUID, url: URL) {
        self.id = id
        self.filename = url.lastPathComponent
        self.url = url
    }
}
