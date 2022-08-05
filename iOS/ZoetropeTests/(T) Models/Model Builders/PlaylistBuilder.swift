//
//  PlaylistBuilder.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 07/02/2021.
//

import Foundation
@testable import Zoetrope

final class PlaylistBuilder {
    private var b_id = UUID()
    private var b_name: String = ""
    private var b_videos: [VideoModel] = []

    @discardableResult func id(_ id: UUID) -> PlaylistBuilder {
        b_id = id
        return self
    }

    @discardableResult func name(_ name: String) -> PlaylistBuilder {
        b_name = name
        return self
    }

    @discardableResult func videos(_ videos: [VideoModel]) -> PlaylistBuilder {
        b_videos = videos
        return self
    }

    func build() -> Playlist {
        Playlist(id: b_id, name: b_name, videos: b_videos)
    }
}
