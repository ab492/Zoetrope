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
        replaceCurrentItemCallCount += 1
        super.replaceCurrentItem(with: item)
    }

    var lastSeek: (time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime)?
    override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) {
        lastSeek = (time, toleranceBefore, toleranceAfter)
        super.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter)
    }
}
