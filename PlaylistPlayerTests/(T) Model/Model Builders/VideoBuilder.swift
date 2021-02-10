//
//  VideoBuilder.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 06/02/2021.
//

import Foundation
@testable import PlaylistPlayer

final class VideoBuilder {
    private var b_id = UUID()
    private var b_url: URL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString)

    @discardableResult func id(_ id: UUID) -> VideoBuilder {
        b_id = id
        return self
    }

    @discardableResult func url(_ url: URL) -> VideoBuilder {
        b_url = url
        return self
    }

    func build() -> Video {
        Video(id: b_id, url: b_url)
    }
}
