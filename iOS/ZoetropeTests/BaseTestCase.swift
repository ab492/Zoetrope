//
//  BaseTestCase.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import XCTest
@testable import Zoetrope

class BaseTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        Current = World(accessibilityService: MockAccessibilityService(),
                        dateTimeService: MockDateTimeService(),
                        playlistManager: MockPlaylistManager(),
                        playlistPlayer: MockPlaylistPlayer(),
                        thumbnailService: MockThumbnailService(),
                        userPreferencesManager: MockUserPreferencesManager())
    }
}

 extension World {
     var mockAccessibilityService: MockAccessibilityService {
         self.accessibilityService as! MockAccessibilityService
     }
     
    var mockDateTimeService: MockDateTimeService {
        self.dateTimeService as! MockDateTimeService
    }

    var mockPlaylistManager: MockPlaylistManager {
        self.playlistManager as! MockPlaylistManager
    }

    var mockThumbnailService: MockThumbnailService {
        self.thumbnailService as! MockThumbnailService
    }

    var mockUserPreferencesManager: MockUserPreferencesManager {
        self.userPreferencesManager as! MockUserPreferencesManager
    }
 }
