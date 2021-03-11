//
//  MockMetadataService.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 10/03/2021.
//

import XCTest
@testable import PlaylistPlayer

final class MockVideoMetadataService: VideoMetadataService {

    enum GenerateVideoBehavior {
        case success(Video?)
        case failure
    }

    var generateVideoBehavior: GenerateVideoBehavior?
    func generateVideoWithMetadataForItemAt(securityScopedURL: URL, completion: @escaping (Video?) -> Void) {

        if let behavior = generateVideoBehavior {
            switch behavior {
            case .success(let video):
                completion(video)
            case .failure:
                completion(nil)
            }
        }
    }

    var cleanupStoreCount = 0
    func cleanupStore(currentVideos: [Video]) {
        cleanupStoreCount += 1
    }

    func url(for video: Video) -> URL? {
        fatalError("Not implemented")
    }

    func removeMetadata(for video: Video) {
        fatalError("Not implemented")
    }


}
