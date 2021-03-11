//
//  MockVideoPlayer.swift
//  QueueTetTests
//
//  Created by Andy Brown on 05/01/2021.
//

import XCTest
import AVFoundation
@testable import PlaylistPlayer

final class MockVideoPlayer: VideoPlayerProtocol {

    var playCallCount = 0
    func play() {
        playCallCount += 1
    }

    var pauseCallCount = 0
    func pause() {
        pauseCallCount += 1
    }

    var seekToTimeCalledCount = 0
    func seek(to time: MediaTime) {
        seekToTimeCalledCount += 1
    }

    var lastReplacedItem: AVPlayerItem?
    func replaceCurrentItem(with item: AVPlayerItem) {
        lastReplacedItem = item
    }

    var observer: VideoPlayerObserver?

    var playbackRate: Float = 0

    var duration: Time = .zero

    var currentTime: Time = .zero

    var status: ItemStatus = .readyToPlay

    var volume: Float = 0

    var playbackState: PlaybackState = .paused

    var mediaIsReadyToPlayFastForward: Bool = true

    var mediaIsReadyToPlayFastReverse: Bool = true

    func cancelPendingSeeks() {

    }

    func step(byFrames count: Int) { }
}
