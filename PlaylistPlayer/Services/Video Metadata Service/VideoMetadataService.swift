//
//  VideoMetadataService.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 14/02/2021.
//

import Foundation
import ABExtensions

protocol VideoMetadataService {
    func generateVideoWithMetadataForItemAt(securityScopedURL: URL, completion: @escaping (VideoModel?) -> Void)
//    func url(for video: Video) -> URL?
    func removeMetadata(for video: VideoModel)
    func cleanupStore(currentVideos: [VideoModel])
}

/// Responsible for building a `Video`, along with creating and storing relevant metadata about the item (e.g. thumbnail, security scoped bookmark).
/// **Although this stores metadata about the item, it's the callers responsibility to save the returned model.**
class VideoMetadataServiceImpl: VideoMetadataService {

    // MARK: - Properties

    private let operationQueue = OperationQueue()
    
    

    private let importAssetConstructor = ImportAssetConstructor()

    // MARK: - Init
    
    init() {
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 3
    }

    // MARK: - Public

    func generateVideoWithMetadataForItemAt(securityScopedURL: URL, completion: @escaping (VideoModel?) -> Void) {
//
//        do {
//            try FileManager.default.copyItem(at: securityScopedURL, to: FileManager.default.documentsDirectory.appendingPathComponent("file.mov"))
//        } catch let error {
//            print("ERROR: 😂 \(error)")
////        }
//        let importAsset = importAssetConstructor.assetFor(sourceURL: securityScopedURL)
//
//        print("IMPORT ASSET: \(importAsset)")
//
//        // Define operations
//        let copyFileToLocationOperation = CopyFileToLocationImportOperation(baseURL: <#URL#>, importAsset: importAsset)
//        let createVideoModelOperation = CreateVideoModelImportOperation(importAsset: importAsset)
//
//        createVideoModelOperation.addDependency(copyFileToLocationOperation)
//
//        operationQueue.addOperation(copyFileToLocationOperation)
//        operationQueue.addOperation(createVideoModelOperation)
//
//
//        createVideoModelOperation.onVideoModelCreated = { video in
//            completion(video)
//        }

//        Current.thumbnailService.generateThumbnail(for: video)
    }

//    func url(for video: Video) -> URL? {
//        print("URL REQUESTED")
//        return video.url
////        securityScopedBookmarkStore.url(for: video.id)
//    }

    func removeMetadata(for video: VideoModel) {
        Current.thumbnailService.removeThumbnail(for: video)
    }

    func cleanupStore(currentVideos: [VideoModel]) {
        Current.thumbnailService.cleanupStoreOfAllExcept(requiredVideos: currentVideos)
    }
}
