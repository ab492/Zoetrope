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

        // TODO: Remove the production `userPreferencesManager` from here and control the date.
        Current = World(date: { Date() },
                         playlistManager: MockPlaylistManager(),
                         thumbnailService: MockThumbnailService(),
                         userPreferencesManager: UserPreferencesManagerImpl())

    }
}

// extension World {
//    var mockSecurityScopedBookmarkStore: MockSecurityScopedBookmarkStore {
//        self.securityScopedBookmarkStore as! MockSecurityScopedBookmarkStore
//    }
//
//    var mockThumbnailService: MockThumbnailService {
//        self.thumbnailService as! MockThumbnailService
//    }
// }
