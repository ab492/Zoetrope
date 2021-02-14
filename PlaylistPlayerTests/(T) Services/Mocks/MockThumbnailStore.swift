//
//  MockThumbnailStore.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import UIKit
@testable import PlaylistPlayer

final class MockThumbnailStore: ThumbnailStore {
    var allThumbnails: [String] {
        fatalError("Not implemented")
    }
    
    func save(image: UIImage, filename: String) throws {
        fatalError("Not implemented")
    }

    func fetch(thumbnailNamed filename: String) -> UIImage? {
        fatalError("Not implemented")
    }

    var lastDeletedThumbnail: String?
    func delete(thumbnailName filename: String) throws {
        lastDeletedThumbnail = filename
    }

    
}
