//
//  SpyAVQueuePlayer.swift
//  QueueTetTests
//
//  Created by Andy Brown on 14/01/2021.
//

import AVFoundation

class SpyAVPlayer: AVPlayer {

    var replaceCurrentItemCallCount = 0

    override func replaceCurrentItem(with item: AVPlayerItem?) {
        super.replaceCurrentItem(with: item)
        replaceCurrentItemCallCount += 1
    }
}
