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
    private var b_duration: Time = Time(seconds: 0)
    private var b_thumbnailFilename: String?

    @discardableResult func id(_ id: UUID) -> VideoBuilder {
        b_id = id
        return self
    }

    @discardableResult func filename(_ filename: String) -> VideoBuilder {
        b_filename = filename
        return self
    }

    @discardableResult func duration(_ duration: Time) -> VideoBuilder {
        b_duration = duration
        return self
    }

    @discardableResult func thumbnailFilename(_ thumbnailFilename: String?) -> VideoBuilder {
        b_thumbnailFilename = thumbnailFilename
        return self
    }

    func build() -> Video {
        Video(id: b_id, filename: b_filename, duration: b_duration, thumbnailFilename: b_thumbnailFilename)
    }
}
