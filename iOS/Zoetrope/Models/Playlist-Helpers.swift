//
//  Playlist-Helpers.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/02/2021.
//

import Foundation

extension Playlist {
    var formattedCount: String {
        switch videos.count {
        case 1:
            return "1 item"
        default:
            return "\(videos.count) items"
        }
    }
}
