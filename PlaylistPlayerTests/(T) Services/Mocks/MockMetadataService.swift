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
        case success(VideoModel?)
        case failure
    }

    var generateVideoBehavior: GenerateVideoBehavior?
    func generateVideoWithMetadataForItemAt(securityScopedURL: URL, completion: @escaping (VideoModel?) -> Void) {

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
    func cleanupStore(currentVideos: [VideoModel]) {
        cleanupStoreCount += 1
    }

    func url(for video: VideoModel) -> URL? {
        fatalError("Not implemented")
    }

    func removeMetadata(for video: VideoModel) {
        fatalError("Not implemented")
    }


}
