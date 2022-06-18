//
//  MockThumbnailService.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import UIKit
@testable import PlaylistPlayer

final class MockThumbnailService: ThumbnailService {
    func generateThumbnail(for video: Video) {
        fatalError("Not implemented yet")

    }

    
    var processingThumbnails: [Video] = []

    func generateThumbnail(for video: Video, at url: URL) {
        fatalError("Not implemented yet")
    }

    func thumbnail(for video: Video) -> UIImage? {
        fatalError("Not implemented yet")
    }

    func cleanupStoreOfAllExcept(requiredVideos: [Video]) {
        fatalError("Not implemented yet")
    }

    var removeThumbnailCallCount = 0
    func removeThumbnail(for video: Video) {
        removeThumbnailCallCount += 1
    }

    var observations = [ObjectIdentifier: LegacyWeakBox<ThumbnailServiceObserver>]()

    func addObserver(_ observer: ThumbnailServiceObserver) {
        // TODO: What to do here?!
    }

    func removeObserver(_ observer: ThumbnailServiceObserver) {
        fatalError("Not implemented yet")
    }
}
