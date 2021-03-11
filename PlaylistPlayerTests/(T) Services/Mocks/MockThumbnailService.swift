//
//  MockThumbnailService.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import UIKit
@testable import PlaylistPlayer

final class MockThumbnailService: ThumbnailService {
    
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

    var observations = [ObjectIdentifier: WeakBox<ThumbnailServiceObserver>]()

    func addObserver(_ observer: ThumbnailServiceObserver) {
        fatalError("Not implemented yet")
    }

    func removeObserver(_ observer: ThumbnailServiceObserver) {
        fatalError("Not implemented yet")
    }
}
