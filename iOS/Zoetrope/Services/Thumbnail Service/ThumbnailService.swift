//
//  ThumbnailService.swift
//  Quickfire
//
//  Created by Andy Brown on 28/12/2020.
//

import Foundation
import UIKit

protocol ThumbnailServiceObserver: AnyObject {
    func processingThumbnailsDidUpdate()
    func didFinishProcessingThumbnails()
}

extension ThumbnailServiceObserver {
    func processingThumbnailsDidUpdate() { }
    func didFinishProcessingThumbnails() { }
}

protocol ThumbnailService {
    var processingThumbnails: [VideoModel] { get }
    func generateThumbnail(for video: VideoModel, at url: URL)
    func thumbnail(for video: VideoModel) -> UIImage?
    func removeThumbnail(for video: VideoModel)
    func cleanupStoreOfAllExcept(requiredVideos: [VideoModel])

    // Observable
    var observations: [ObjectIdentifier: WeakBox<ThumbnailServiceObserver>] { get set }
    func addObserver(_ observer: ThumbnailServiceObserver)
    func removeObserver(_ observer: ThumbnailServiceObserver)
}

final class ThumbnailServiceImpl: ThumbnailService {

    private(set) var processingThumbnails = [VideoModel]()

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
    func generateThumbnail(for video: VideoModel, at url: URL) {
        processingThumbnails.append(video)
        thumbnailsDidUpdate()

        let generateThumbnailOperation = GenerateThumbnailOperation(url: url)

        generateThumbnailOperation.onComplete = { [weak self] image in
            guard let self = self else { return }

            self.processingThumbnails.removeAll(where: { $0.id == video.id })
            self.thumbnailsDidUpdate()

            guard let thumbnail = image else { return }
            let filename = UUID().uuidString

            do {
                try self.thumbnailStore.save(image: thumbnail, filename: filename)
                video.thumbnailFilename = filename
                if self.processingThumbnails.isEmpty {
                    self.didFinishProcessingThumbnails()
                }
            } catch let error {
                print("Unable to save image: \(error.localizedDescription)")
            }
        }
        operationQueue.addOperation(generateThumbnailOperation)
    }

    func thumbnail(for video: VideoModel) -> UIImage? {
        guard let name = video.thumbnailFilename else { return nil }
        return thumbnailStore.fetch(thumbnailNamed: name)
    }

    func removeThumbnail(for video: VideoModel) {
        guard let name = video.thumbnailFilename else { return }
        do {
            try thumbnailStore.delete(thumbnailName: name)
            video.thumbnailFilename = nil
        } catch let error {
            print("Unable to save image: \(error)")
        }
    }

    func cleanupStoreOfAllExcept(requiredVideos: [VideoModel]) {
        let filenamesToKeep = Set(requiredVideos.compactMap { $0.thumbnailFilename })
        let allFilenamesInStore = Set(thumbnailStore.allThumbnailFilenames)
        let filenamesToDelete = allFilenamesInStore.subtracting(filenamesToKeep)

        for filename in filenamesToDelete {
            do {
                try thumbnailStore.delete(thumbnailName: filename)
            } catch let error {
                print("Unable to remove image: \(error)")
            }
        }
    }
    
    // MARK: - Observable

    private func thumbnailsDidUpdate() {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.processingThumbnailsDidUpdate()
        }
    }

    private func didFinishProcessingThumbnails() {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.didFinishProcessingThumbnails()
        }
    }

    var observations = [ObjectIdentifier: WeakBox<ThumbnailServiceObserver>]()

    func addObserver(_ observer: ThumbnailServiceObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = WeakBox(observer)
    }

    func removeObserver(_ observer: ThumbnailServiceObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
