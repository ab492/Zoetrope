//
//  MockThumbnailService.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import UIKit
@testable import PlaylistPlayer

final class MockThumbnailService: ThumbnailService {
    func generateThumbnail(for video: VideoModel) {
        fatalError("Not implemented yet")

    }

    
    var processingThumbnails: [VideoModel] = []

    func generateThumbnail(for video: VideoModel, at url: URL) {
        fatalError("Not implemented yet")
    }

    func thumbnail(for video: VideoModel) -> UIImage? {
        fatalError("Not implemented yet")
    }

    func cleanupStoreOfAllExcept(requiredVideos: [VideoModel]) {
        fatalError("Not implemented yet")
    }

    var removeThumbnailCallCount = 0
    func removeThumbnail(for video: VideoModel) {
        removeThumbnailCallCount += 1
    }

    var observations = [ObjectIdentifier: WeakBox<ThumbnailServiceObserver>]()

    func addObserver(_ observer: ThumbnailServiceObserver) {
        // TODO: What to do here?!
    }

    func removeObserver(_ observer: ThumbnailServiceObserver) {
        fatalError("Not implemented yet")
    }
}
