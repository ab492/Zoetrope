//
//  VideoMetadataService.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 14/02/2021.
//

import Foundation

protocol VideoMetadataService {
    func generateVideoWithMetadataForItemAt(securityScopedURL: URL) -> Video?
    func removeMetadata(for video: inout Video)
    func cleanupStore(currentVideos: [Video])
}

/// Responsible for building a `Video`, along with creating and storing relevant metadata about the item (e.g. thumbnail, security scoped bookmark).
/// **Although this stores metadata about the item, it's the callers responsibility to save the returned model.**
class VideoMetadataServiceImpl: VideoMetadataService {

    // MARK: - Properties

    private var durationCalculator: DurationCalculator

    // MARK: - Init

    init(durationCalculator: DurationCalculator) {
        self.durationCalculator = durationCalculator
    }

    convenience init() {
        self.init(durationCalculator: DurationCalculatorImpl())
    }

    // MARK: - Public

    func generateVideoWithMetadataForItemAt(securityScopedURL: URL) -> Video? {
        let filename = FileManager.default.displayName(atPath: securityScopedURL.path)
        let id = UUID()

        guard let fileBookmark = SecurityScopedBookmark(id: id, securityScopedURL: securityScopedURL) else { return nil }
        Current.securityScopedBookmarkStore.add(bookmark: fileBookmark)

        // Fetch the URL for bookmark we just saved, which is suitable for querying and generating metadata.
        guard let actualURL = Current.securityScopedBookmarkStore.url(for: id) else { return nil }

        let duration = durationCalculator.durationForAsset(at: actualURL)
        var video = Video(id: id, filename: filename, duration: duration)
        Current.thumbnailService.generateThumbnail(for: &video, at: actualURL)
        return video
    }

    func removeMetadata(for video: inout Video) {
        Current.securityScopedBookmarkStore.removeBookmark(for: video.id)
        Current.thumbnailService.removeThumbnail(for: &video)
    }

    func cleanupStore(currentVideos: [Video]) {
        fatalError("Not implemented")
        // Clear any thumbnails out that aren't in current
        // Clear any bookmarks out that aren't in current
    }
}
