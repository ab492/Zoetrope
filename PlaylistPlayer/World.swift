//
//  World.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 10/02/2021.
//

import Foundation

var Current = World(date: { Date() },
                    playlistManager: PlaylistManager(),
                    securityScopedBookmarkStore: SecurityScopedBookmarkStoreImpl(),
                    thumbnailService: ThumbnailServiceImpl())

//https://stackoverflow.com/questions/48048190/how-to-inject-protocol-with-associated-types?rq=1
struct World<T: ThumbnailService> {
    var date: () -> Date
    var playlistManager: PlaylistManager
    var securityScopedBookmarkStore: SecurityScopedBookmarkStore
    var thumbnailService: T
}
