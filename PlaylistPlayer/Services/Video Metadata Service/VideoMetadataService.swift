//
//  VideoMetadataService.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 14/02/2021.
//

import Foundation

protocol VideoMetadataService {
    func generateVideoWithMetadataForItemAt(securityScopedURL: URL, completion: @escaping (Video?) -> Void)
    func url(for video: Video) -> URL?
    func removeMetadata(for video: inout Video)
    func cleanupStore(currentVideos: [Video])
}

/// Responsible for building a `Video`, along with creating and storing relevant metadata about the item (e.g. thumbnail, security scoped bookmark).
/// **Although this stores metadata about the item, it's the callers responsibility to save the returned model.**
class VideoMetadataServiceImpl: VideoMetadataService {

    // MARK: - Properties

    private var durationCalculator: DurationCalculator
    private var securityScopedBookmarkStore: SecurityScopedBookmarkStore
    private let operationQueue = OperationQueue()

    // MARK: - Init

    init(durationCalculator: DurationCalculator, securityScopedBookmarkStore: SecurityScopedBookmarkStore) {
        self.durationCalculator = durationCalculator
        self.securityScopedBookmarkStore = securityScopedBookmarkStore
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1
    }

    convenience init() {
        self.init(durationCalculator: DurationCalculatorImpl(),
                  securityScopedBookmarkStore: SecurityScopedBookmarkStoreImpl())
    }

    // MARK: - Public

    func generateVideoWithMetadataForItemAt(securityScopedURL: URL, completion: @escaping (Video?) -> Void) {
        let filename = FileManager.default.displayName(atPath: securityScopedURL.path)
        let id = UUID()

        // Try just bookmark operation and look at start time vs finish time. Then add in duration operation.

        let securityScopedBookmarkOperation = SecurityScopedBookmarkOperation(securityScopedBookmarkStore: securityScopedBookmarkStore,
                                                                              id: id,
                                                                              securityScopedURL: securityScopedURL)
        let durationCalculatorOperation = DurationCalculatorOperation()
        durationCalculatorOperation.addDependency(securityScopedBookmarkOperation)

        durationCalculatorOperation.onComplete = { [weak self] duration in
            guard let self = self else { return }

            let video = Video(id: id, filename: filename, duration: duration)
            if let url = self.securityScopedBookmarkStore.url(for: id) {
                Current.thumbnailService.generateThumbnail(for: video, at: url)
            }
            completion(video)
        }

        operationQueue.addOperation(securityScopedBookmarkOperation)
        operationQueue.addOperation(durationCalculatorOperation)
    }

    func url(for video: Video) -> URL? {
        securityScopedBookmarkStore.url(for: video.id)
    }


// This is for testing.
//    func generateVideoWithMetadataForItemAt(securityScopedURL: URL, completion: @escaping (Video?) -> Void) {
//        let filename = FileManager.default.displayName(atPath: securityScopedURL.path)
//        let id = UUID()
//
//        // Try just bookmark operation and look at start time vs finish time. Then add in duration operation.
//
//        let securityScopedBookmarkOperation = SecurityScopedBookmarkOperation(id: id, securityScopedURL: securityScopedURL)
//
//        securityScopedBookmarkOperation.onComplete = { url in
//            print("Bookmark operation complete :\(id)")
//            completion(nil)
//        }
//
//        operationQueue.addOperation(securityScopedBookmarkOperation)
//    }

    func removeMetadata(for video: inout Video) {
        securityScopedBookmarkStore.removeBookmark(for: video.id)
        Current.thumbnailService.removeThumbnail(for: video)
    }

    func cleanupStore(currentVideos: [Video]) {
        fatalError("Not implemented")
        // Clear any thumbnails out that aren't in current
        // Clear any bookmarks out that aren't in current
    }
}
