//
//  MediaStore.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 08/02/2021.
//

import Foundation

final class MediaStoreImpl {

    // MARK: - Properties

    private let location: URL
    private let fileManager = FileManager.default

    // MARK: - Init

    init(location: URL) {
        self.location = location
    }

    convenience init() {
        let defaultLocation = FileManager.default.documentsDirectory
            .appendingPathComponent("Media")
        self.init(location: defaultLocation)
    }


    /// Copies an item to the media store.
    /// - Parameter url: The location to copy from. You must have permission to access this file, or the process will fail.
    /// - Throws: Copying an item can fail, so the error is passed on.
    /// - Returns: A relative path to the location, which can be persisted so that item can be retrieved at a later date.
    func copyItemToStore(from url: URL) throws -> String? {
        createStorageDirectoryIfRequired()

        let fullURL = location.appendingPathComponent(url.lastPathComponent)
        
        do {
            try fileManager.copyItem(at: url, to: fullURL)
            return fullURL.relativePath
        } catch let error {
            throw error
        }
    }

    func urlForItemAt(relativePath: String) -> URL {
        return URL(fileURLWithPath: relativePath, relativeTo: location)
    }
    

    // MARK: - Private

    private func createStorageDirectoryIfRequired() {
        if fileManager.fileExists(atPath: location.relativePath) == false {
            try? fileManager.createDirectory(at: location, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
