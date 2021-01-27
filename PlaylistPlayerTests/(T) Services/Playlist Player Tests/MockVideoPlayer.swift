//
//  MockVideoPlayer.swift
//  QueueTetTests
//
//  Created by Andy Brown on 05/01/2021.
//

import XCTest
import AVFoundation
@testable import PlaylistPlayer

final class MockVideoPlayer: VideoQueuePlayerProtocol {

    var queuedItems: [AVPlayerItem]?
    func queueItems(_ items: [AVPlayerItem]) {
        self.queuedItems = items
    }

    var advanceToNextItemCalledCount = 0
    func advanceToNextItem() {
        advanceToNextItemCalledCount += 1
    }
    
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

    var removeAllItemsCallCount = 0
    func removeAllItems() {
        removeAllItemsCallCount += 1
    }

    var insertedItems = [AVPlayerItem]()
    func insert(item: AVPlayerItem, after: AVPlayerItem?) {
        insertedItems.append(item)
    }

    // MARK: - Not Implemented

    var observer: VideoPlayerObserver? = nil

    var playbackRate: Float = 0

    var duration: Time = Time(seconds: 0)

    var currentTime: Time = Time(seconds: 0)

    var volume: Float = 1

    var status: ItemStatus = .readyToPlay

    var playbackState: PlaybackState = .paused

    var mediaIsReadyToPlayFastForward: Bool = true

    var mediaIsReadyToPlayFastReverse: Bool = true

    func items() -> [AVPlayerItem] { [] }

    func canInsert(item: AVPlayerItem, after: AVPlayerItem?) -> Bool { true }
    
    func remove(item: AVPlayerItem) { }

    func replaceCurrentItem(with url: URL) { }

    func step(byFrames count: Int) { }
}


