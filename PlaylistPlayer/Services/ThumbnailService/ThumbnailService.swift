//
//  ThumbnailService.swift
//  Quickfire
//
//  Created by Andy Brown on 28/12/2020.
//

import Foundation
import UIKit

protocol ThumbnailService {
    func generateThumbnail(for video: inout Video, at url: URL)
    func thumbnail(for video: Video) -> UIImage?
    func removeThumbnail(for video: inout Video)
}

final class ThumbnailServiceImpl: ThumbnailService {

    // MARK: - Properties

    private let thumbnailStore: ThumbnailStore

    // MARK: - Init

    init(thumbnailStore: ThumbnailStore) {
        self.thumbnailStore = thumbnailStore
    }

    convenience init() {
        self.init(thumbnailStore: ThumbnailStoreImpl())
    }

    // MARK: - Public

    func generateThumbnail(for video: inout Video, at url: URL) {
        if let thumbnail = ThumbnailGenerator.thumbnail(for: url) {
            let filename = UUID().uuidString
            do {
                try thumbnailStore.save(image: thumbnail, filename: filename)
                video.thumbnailFilename = filename
            } catch let error {
                print("Unable to save image: \(error)")
            }
        }
    }

    func thumbnail(for video: Video) -> UIImage? {
        guard let name = video.thumbnailFilename else { return nil }
        return thumbnailStore.fetch(thumbnailNamed: name)
    }

    func removeThumbnail(for video: inout Video) {
        guard let name = video.thumbnailFilename else { return }
        do {
            try thumbnailStore.delete(thumbnailName: name)
            video.thumbnailFilename = nil
        } catch let error {
            print("Unable to save image: \(error)")
        }
    }
}
