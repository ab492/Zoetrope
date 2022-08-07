//
//  MockVideoPlayer.swift
//  QueueTetTests
//
//  Created by Andy Brown on 05/01/2021.
//

import XCTest
import AVFoundation
@testable import VideoQueuePlayer

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
    var lastSeekedToTime: MediaTime?
    func seek(to time: MediaTime) {
        seekToTimeCalledCount += 1
        lastSeekedToTime = time
    }

    var lastReplacedItem: PlayerItem?
    func replaceCurrentItem(with item: PlayerItem) {
        lastReplacedItem = item
    }

    var playbackRate: Float = 0

    var observer: VideoPlayerObserver?


    var duration: MediaTime = .zero

    var currentTime: MediaTime = .zero

    var status: ItemStatus = .readyToPlay

    var volume: Float = 0

    var playbackState: PlaybackState = .paused

    var mediaIsReadyToPlayFastForward: Bool = true

    var mediaIsReadyToPlayFastReverse: Bool = true

    func cancelPendingSeeks() {

    }

    func step(byFrames count: Int) { }

    func setVideoPlayer(view: PlayerView) { }
}
