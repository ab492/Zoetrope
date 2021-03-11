//
//  MockThumbnailStore.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import UIKit
@testable import PlaylistPlayer

final class MockThumbnailStore: ThumbnailStore {

    var allThumbnailFilenames: [String] = []

    func save(image: UIImage, filename: String) throws {
        fatalError("Not implemented")
    }

    func fetch(thumbnailNamed filename: String) -> UIImage? {
        fatalError("Not implemented")
    }

    var deletedThumbnails = [String]()
    func delete(thumbnailName filename: String) throws {
        deletedThumbnails.append(filename)
    }

}
