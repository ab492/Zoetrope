//
//  MockUserPreferencesManager.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 12/03/2021.
//

import UIKit
import Foundation
@testable import PlaylistPlayer

final class MockUserPreferencesManager: UserPreferencesManager {

    var lastUpdatedLoopMode: LoopMode?
    var loopMode: LoopMode = .playPlaylistOnce {
        didSet {
            print("CALLED loop mode: \(loopMode)")
            lastUpdatedLoopMode = loopMode
        }
    }

    var overlayNotes: Bool = false

    var noteColor: UIColor = UIColor.white
}
