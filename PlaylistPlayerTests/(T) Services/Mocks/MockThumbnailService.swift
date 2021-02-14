//
//  MockThumbnailService.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import UIKit
@testable import PlaylistPlayer

final class MockThumbnailService: ThumbnailService {
    func generateThumbnail(for video: inout Video, at url: URL) {
        fatalError("Not implemented yet")
    }

    func thumbnail(for video: Video) -> UIImage? {
        fatalError("Not implemented yet")
    }

    var removeThumbnailCallCount = 0
    func removeThumbnail(for video: inout Video) {
        removeThumbnailCallCount += 1
    }
}
