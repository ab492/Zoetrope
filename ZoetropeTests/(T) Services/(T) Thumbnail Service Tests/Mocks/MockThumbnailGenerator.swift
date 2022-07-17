//
//  MockThumbnailGenerator.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 01/03/2021.
//

import UIKit
@testable import PlaylistPlayer

final class MockThumbnailGenerator: ThumbnailGenerator {

    var thumbnailToReturn: UIImage?
    func thumbnail(for url: URL) -> UIImage? {
        thumbnailToReturn
    }
}
