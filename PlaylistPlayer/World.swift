//
//  World.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

var Current = World(date: { Date() }, playlistManager: PlaylistManager())

struct World {
    var date: () -> Date
    var playlistManager: PlaylistManager
}
