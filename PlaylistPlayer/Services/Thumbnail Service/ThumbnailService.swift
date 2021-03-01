//
//  ThumbnailService.swift
//  Quickfire
//
//  Created by Andy Brown on 28/12/2020.
//

import Foundation
import UIKit

protocol ThumbnailService: ObservableObject {
    var processingThumbnails: [Video] { get }
    func generateThumbnail(for video: Video, at url: URL)
    func thumbnail(for video: Video) -> UIImage?
    func removeThumbnail(for video: Video)
}

final class ThumbnailServiceImpl: ThumbnailService {
    
    @Published var processingThumbnails = [Video]()

    // MARK: - Properties

    private let thumbnailStore: ThumbnailStore
    private let operationQueue = OperationQueue()

    // MARK: - Init

    init(thumbnailStore: ThumbnailStore) {
        self.thumbnailStore = thumbnailStore
        operationQueue.qualityOfService = .userInitiated
    }

    convenience init() {
        self.init(thumbnailStore: ThumbnailStoreImpl())
    }

    // MARK: - Public

    /// Starts off an operation the generate a thumbnail for a given video. This work will be done in the background but **will not** block the calling thread.
    func generateThumbnail(for video: Video, at url: URL) {
        processingThumbnails.append(video)

        let generateThumbnailOperation = GenerateThumbnailOperation(url: url)

        generateThumbnailOperation.onComplete = { image in
            self.processingThumbnails.removeAll(where: { $0.id == video.id })

            guard let thumbnail = image else { return }
            let filename = UUID().uuidString

            do {
                try self.thumbnailStore.save(image: thumbnail, filename: filename)
                video.thumbnailFilename = filename
                Current.playlistManager.save() // TODO: Is there a better way to save this information?!
            } catch let error {
                print("Unable to save image: \(error.localizedDescription)")
            }
        }
        operationQueue.addOperation(generateThumbnailOperation)
    }

    func thumbnail(for video: Video) -> UIImage? {
        guard let name = video.thumbnailFilename else { return nil }
        return thumbnailStore.fetch(thumbnailNamed: name)
    }

    func removeThumbnail(for video: Video) {
        guard let name = video.thumbnailFilename else { return }
        do {
            try thumbnailStore.delete(thumbnailName: name)
            video.thumbnailFilename = nil
            // TODO: Need to save this when things change!
        } catch let error {
            print("Unable to save image: \(error)")
        }
    }
}
