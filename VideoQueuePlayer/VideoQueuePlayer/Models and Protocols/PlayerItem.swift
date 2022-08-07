//
//  PlayerItem.swift
//  VideoQueuePlayer
//
//  Created by Andy Brown on 07/08/2022.
//

import Foundation

public protocol PlayerItem {
    var url: URL { get }
    func seek(to time: MediaTime)
    func isSame(as other: PlayerItem) -> Bool
}
