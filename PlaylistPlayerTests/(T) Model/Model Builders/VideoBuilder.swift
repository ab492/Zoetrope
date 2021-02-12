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
    private var b_filename: String = ""

    @discardableResult func id(_ id: UUID) -> VideoBuilder {
        b_id = id
        return self
    }

    @discardableResult func filename(_ filename: String) -> VideoBuilder {
        b_filename = filename
        return self
    }

    func build() -> Video {
        Video(id: b_id, filename: b_filename)
    }
}
