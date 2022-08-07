//
//  PlaylistPlayerIntegrationTests.swift
//  QueueTetTests
//
//  Created by Andy Brown on 13/01/2021.
//

import XCTest
import AVFoundation
@testable import VideoQueuePlayer

class VideoQueuePlayer_AVPlayer_IntegrationTests: XCTestCase {

    private var spyAvPlayer: SpyAVPlayer!

    override func setUp() {
        super.setUp()

        spyAvPlayer = SpyAVPlayer()
    }

    func test_initialPlay_addsCorrectItemToPlayer() {
        let testItems = makeAvPlayerItems(number: 3)
        let playlistPlayer = makeSUT(withItems: testItems)

        playlistPlayer.play()

        XCTAssertEqual(spyAvPlayer.currentItem, testItems[0])
    }

    func test_playNext_worksCorrectly() {
        let testItems = makeAvPlayerItems(number: 3)
        let playlistPlayer = makeSUT(withItems: testItems)

        playlistPlayer.playNext()

        XCTAssertEqual(spyAvPlayer.currentItem, testItems[1])
    }

    func test_playPrevious_worksCorrectly() {
        let testItems = makeAvPlayerItems(number: 3)
        let playlistPlayer = makeSUT(withItems: testItems)

        playlistPlayer.playNext()       // Skip to item 2 (index 1)
        playlistPlayer.playPrevious()   // Skip back to item 1 (index 0)

        XCTAssertEqual(spyAvPlayer.currentItem, testItems[0])
    }

    func test_defaultState_isPaused() {
        let testItems = makeAvPlayerItems(number: 3)
        makeSUT(withItems: testItems)

        XCTAssertEqual(spyAvPlayer.timeControlStatus, .paused)
    }

    func test_loopPlaylist_loopsAroundOnceEndOfQueueReached() {
        let testItems = makeAvPlayerItems(number: 3)
        let playlistPlayer = makeSUT(withItems: testItems)
        playlistPlayer.loopMode = .loopPlaylist

        playlistPlayer.playNext() // Skip to item 2 (index 1)
        playlistPlayer.playNext() // Skip to item 3 (index 2)
        playlistPlayer.playNext() // Loop back around to item 1 (index 0)

        XCTAssertEqual(spyAvPlayer.currentItem, testItems[0])
    }

    func test_skipToIndex_worksCorrectly() {
        let testItems = makeAvPlayerItems(number: 5)
        let playlistPlayer = makeSUT(withItems: testItems)

        playlistPlayer.skipToItem(at: 3)

        XCTAssertEqual(spyAvPlayer.currentItem, testItems[3])
    }

    // MARK: - Seeking

    func test_seekToTime_correctlyMapsToCmTimeOnAvPlayer() {
        let testItems = makeAvPlayerItems(number: 5)
        let playlistPlayer = makeSUT(withItems: testItems)
        let expectedCmTime = CMTime(seconds: 1.765343, preferredTimescale: 6000)

        playlistPlayer.seek(to: MediaTime(seconds: 1.765343, preferredTimescale: 6000))

        XCTAssertEqual(spyAvPlayer.lastSeek?.time, expectedCmTime)
        XCTAssertEqual(spyAvPlayer.lastSeek?.toleranceBefore, .zero)
        XCTAssertEqual(spyAvPlayer.lastSeek?.toleranceAfter, .zero)
    }
}

// MARK: - Helpers

extension VideoQueuePlayer_AVPlayer_IntegrationTests {

    @discardableResult private func makeSUT(withItems items: [AVPlayerItem]) -> VideoQueuePlayer {
        // Create a `WrappedAVQueuePlayer` but inject the `SpyAVPlayer` so we can observe.
        let player = WrappedAVPlayer(player: spyAvPlayer)
        return VideoQueuePlayer(items: items, videoPlayer: player)
    }

    private func makeAvPlayerItems(number: Int) -> [AVPlayerItem] {
        assert(number < 9, "Expected a maximum of 8 items.")

        let testBundle = Bundle(for: type(of: self))

        let avItems = ["01", "02", "03", "04", "05", "06", "07", "08"]
            .compactMap { testBundle.url(forResource: $0, withExtension: "mov") }
            .map { AVPlayerItem(url: $0) }

        assert(avItems.count == 8, "Expected 8 movs in bundle to correctly create test items.")

        var itemsToReturn = [AVPlayerItem]()

        for index in 0...number - 1 {
            itemsToReturn.append(avItems[index])
        }
        return itemsToReturn
    }
}
