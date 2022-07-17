//
//  ThumbnailStore.swift
//  Quickfire
//
//  Created by Andy Brown on 28/12/2020.
//

import Foundation
import UIKit

/// An object for persisting and managing thumbnails on disk.
protocol ThumbnailStore {

    /// Returns all filenames for the thumbnails stored on disk. **These do not contain extensions.**
    var allThumbnailFilenames: [String] { get }

    /// Saves an image with a given filename.
    /// - Parameters:
    ///   - image: A `UIImage` with any compression/processing done in advance.
    ///   - filename: The filename of the image. **This should not include an extension.**
    /// - Throws: Throws an error if the write was unsuccessful.
    func save(image: UIImage, filename: String) throws

    /// Fetches a thumbnail with a given filename, if it exists in the store.
    /// - Parameter filename: The filename of the image. **This should not include an extension.**
    func fetch(thumbnailNamed filename: String) -> UIImage?

    /// Deletes a thumbnail with a given filename, if it exists in the store.
    /// - Parameter filename: The filename of the image. **This should not include an extension.**
    func delete(thumbnailName filename: String) throws
}

final class ThumbnailStoreImpl: ThumbnailStore {

    // MARK: - Properties

    private let location: URL
    private let fileManager = FileManager.default
    private let imageExtension = "jpg"

    // MARK: - Init

    init(directory: URL) {
        self.location = directory
    }

    convenience init() {
        let defaultLocation = FileManager.default.documentsDirectory
            .appendingPathComponent("Thumbnails")
        self.init(directory: defaultLocation)
    }

    // MARK: - Public

    var allThumbnailFilenames: [String] {
        do {
            let files = try fileManager.contentsOfDirectory(at: location, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            let imageFilenames = files
                .filter { $0.pathExtension == imageExtension }
                .map { fileManager.displayName(atPath: $0.deletingPathExtension().path) }
            return imageFilenames
        } catch {
            return []
        }
    }

    func save(image: UIImage, filename: String) throws {
        createStorageDirectoryIfRequired()

        if let data = image.jpegData(compressionQuality: 1) {
            let url = location
                .appendingPathComponent(filename)
                .appendingPathExtension(imageExtension)

            do {
                try data.write(to: url)
            } catch let error {
                throw error
            }
        }
    }

    func fetch(thumbnailNamed filename: String) -> UIImage? {
        let relativePath = path(for: filename).relativePath
        return UIImage(contentsOfFile: relativePath)
    }

    func delete(thumbnailName filename: String) throws {
        let relativePath = path(for: filename).relativePath

        do {
            try fileManager.removeItem(atPath: relativePath)
        } catch let error {
            throw error
        }
    }

    // MARK: - Private

    private func createStorageDirectoryIfRequired() {
        if fileManager.fileExists(atPath: location.relativePath) == false {
            try? fileManager.createDirectory(at: location, withIntermediateDirectories: true, attributes: nil)
        }
    }

    private func path(for filename: String) -> URL {
        location.appendingPathComponent(filename).appendingPathExtension(imageExtension)
    }
}
