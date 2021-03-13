//
//  MockUserPreferencesManager.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 12/03/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockUserPreferencesManager: UserPreferencesManager {
    var sortByTitleOrder: SortOrder = .ascending
    var sortByDurationOrder: SortOrder = .ascending

    var lastUpdatedLoopMode: LoopMode?
    var loopMode: LoopMode = .playPlaylistOnce {
        didSet {
            lastUpdatedLoopMode = loopMode
        }
    }
}
