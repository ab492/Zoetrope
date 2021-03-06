//
//  BaseTestCase.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import XCTest
@testable import PlaylistPlayer

class BaseTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        // TODO: Remove the production `playlistManager` from here and control the date.
        let test = World(date: { Date() },
                         playlistManager: PlaylistManagerImpl(),
                         securityScopedBookmarkStore: MockSecurityScopedBookmarkStore(),
                         thumbnailService: MockThumbnailService())

        
    }
}

//extension World {
//    var mockSecurityScopedBookmarkStore: MockSecurityScopedBookmarkStore {
//        self.securityScopedBookmarkStore as! MockSecurityScopedBookmarkStore
//    }
//
//    var mockThumbnailService: MockThumbnailService {
//        self.thumbnailService as! MockThumbnailService
//    }
//}

