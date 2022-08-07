//
//  MockUserPreferencesManager.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 12/03/2021.
//

import UIKit
import Foundation
import VideoQueuePlayer
@testable import Zoetrope

final class MockUserPreferencesManager: UserPreferencesManager {
    
    var lastUpdatedLoopMode: LoopMode?
    var loopMode: LoopMode = .playPlaylistOnce {
        didSet { lastUpdatedLoopMode = loopMode }
    }
    
    var lastUpdatedUseControlsTimer: Bool?
    var useControlsTimer: Bool = false {
        didSet { lastUpdatedUseControlsTimer = useControlsTimer}
    }
    
    var lastUpdatedShowControlsTime: Int?
    var showControlsTime: Int = 3 {
        didSet { lastUpdatedShowControlsTime = showControlsTime }
    }
}
