//
//  PlaylistPlayerTests.swift
//  QueueTetTests
//
//  Created by Andy Brown on 05/01/2021.
//

import XCTest
import AVFoundation
@testable import PlaylistPlayer

final class VideoQueuePlayerTests: XCTestCase {

    private var mockVideoPlayer: MockVideoPlayer!

    override func setUp() {
        super.setUp()

        mockVideoPlayer = MockVideoPlayer()
    }

    // MARK: - Init and Basic Functionality

    func test_initialState() {
        let sut = makeSUT()

        XCTAssertEqual(sut.nowPlayingIndex, 0)
        XCTAssertEqual(sut.loopMode, .playPlaylistOnce)
    }

    func test_playCallsPlay() {
        let sut = makeSUT()

        sut.play()

        XCTAssertEqual(mockVideoPlayer.playCallCount, 1)
    }

    func test_callingPlayWithEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: 0)

        sut.play()
    }

    func test_playReplacesCurrentItemIfRequired() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.play()

        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items.first)
    }

    func test_pauseCallsPause() {
        let sut = makeSUT()

        sut.pause()

        XCTAssertEqual(mockVideoPlayer.pauseCallCount, 1)
    }

    // MARK: - Play Next Item (Default Loop Mode)

    func test_playNext_incrementsNowPlayingIndexAndReplacesCurrentItem() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.playNext() // Skip to item 2 (index 1)

        XCTAssertEqual(sut.nowPlayingIndex, 1)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[1])
    }

    func test_itemDidFinishPlayingCallback_incrementsPlayingIndex() {
        let sut = makeSUT()

        XCTAssertEqual(sut.nowPlayingIndex, 0)
        sut.currentItemDidFinishPlayback()
        XCTAssertEqual(sut.nowPlayingIndex, 1)
    }

    func test_itemDidFinishPlayingCallback_replacesCurrentItem() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.currentItemDidFinishPlayback()

        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[1])
    }

    // MARK: - Play Previous Item

    func test_playPreviousItem() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.playNext()      // Skip to item 2 (index 1)
        sut.playNext()      // Skip to item 3 (index 2)
        sut.playPrevious()  // Skip to item 2 (index 1)

        XCTAssertEqual(sut.nowPlayingIndex, 1)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[1])
    }

    func test_playPreviousAtBeginningOfQueue_doesntDecrementNowPlayingIndex() {
        let sut = makeSUT()

        sut.playPrevious()

        XCTAssertEqual(sut.nowPlayingIndex, 0)
    }

    func test_playPreviousItemAtBeginning_seeksToZero() {
        let sut = makeSUT()

        sut.playPrevious()

        XCTAssertEqual(mockVideoPlayer.seekToTimeCalledCount, 1)
    }

    // MARK: - Looping Whole Playlist

    func test_loopWholePlaylist_loopsBackToBeginningAtEndOfQueue() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.loopMode = .loopPlaylist

        sut.playNext() // Skip to item 2 (index 1)
        sut.playNext() // Skip to item 3 (index 2)
        sut.playNext() // Loop back around to item 1 (index 0)

        XCTAssertEqual(sut.nowPlayingIndex, 0)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[0])
    }

    func test_loopWholePlaylist_indexBackToBeginningOnItemDidFinish() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopPlaylist
        sut.playNext()
        sut.playNext() // Last item in playlist

        sut.currentItemDidFinishPlayback()

        XCTAssertEqual(sut.nowPlayingIndex, 0)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[0])
    }

    // MARK: - Playing Playlist Once

    func test_playNextAtEndOfQueue_doesntIncrementNowPlayingIndex() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .playPlaylistOnce
        sut.playNext() // Skip to item 2 (index 1)
        sut.playNext() // Skip to item 3 (index 2) - end of playlist

        sut.playNext()

        XCTAssertEqual(sut.nowPlayingIndex, 2)
    }

    func test_playOnce_doesntIncrementOnItemDidFinish() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .playPlaylistOnce
        sut.playNext() // Skip to item 2 (index 1)
        sut.playNext() // Skip to item 3 (index 2) - end of playlist

        sut.currentItemDidFinishPlayback()

        XCTAssertEqual(sut.nowPlayingIndex, 2)
    }

    // MARK: - Loop Current

    func test_loopCurrent_playNextIncrementsNowPlayingIndex() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .loopCurrent

        sut.playNext() // Start looping item 2 (index 1)
        sut.playNext() // Start looping item 3 (index 2)

        XCTAssertEqual(sut.nowPlayingIndex, 2)
    }

    func test_loopCurrent_doesntIncrementOnItemDidFinish() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopCurrent

        sut.playNext() // Start looping item 2 (index 1)
        sut.currentItemDidFinishPlayback()

        XCTAssertEqual(sut.nowPlayingIndex, 1)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[1])
    }

    func test_playNextWithLoopCurrent_doesntIncrementOnceAtEndOfQueue() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopCurrent

        sut.playNext() // Start looping item 2 (index 1)
        sut.playNext() // Start looping item 3 (index 2) - end of playlist
        sut.playNext() // Loop back around to item 1 (index 0)

        XCTAssertEqual(sut.nowPlayingIndex, 0)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[0])
    }

    // MARK: - Skip to Specific Index

    func test_skipToIndex_worksCorrectly() {
        let items = testItems(number: 8)
        let sut = makeSUT(withItems: items)

        sut.skipToItem(at: 3)

        XCTAssertEqual(sut.nowPlayingIndex, 3)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[3])
    }

    func test_skipToIndexWithNegative_defaultsTo0() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.skipToItem(at: -1)

        XCTAssertEqual(sut.nowPlayingIndex, 0)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[0])
    }

    func test_skipToIndexWithNegative_defaultsToMax() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.skipToItem(at: 5)

        XCTAssertEqual(sut.nowPlayingIndex, 2)
        XCTAssertEqual(mockVideoPlayer.lastReplacedItem, items[2])
    }

    // MARK: - Replacing Queue

    func test_replacingQueueWorksCorrectly() {
        let items = testItems(number: 8)
        let sut = makeSUT(withItems: items)

        let newItems = testItems(number: 3)
        sut.replaceQueue(with: newItems)

        XCTAssertEqual(sut.nowPlayingIndex, 0)
    }

    // MARK: - Seeking

    func test_seekingCorrectlyPreservesMediaTime() {
        let sut = makeSUT(withItems: 1)

        sut.seek(to: MediaTime(seconds: 1.7653))

        XCTAssertEqual(mockVideoPlayer.lastSeekedToTime, MediaTime(seconds: 1.7653))
    }


    // MARK: - Empty Playlist Behavior

    func test_callingPlayOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.play()

        XCTAssertEqual(mockVideoPlayer.playCallCount, 0)
    }

    func test_callingPauseOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.pause()

        XCTAssertEqual(mockVideoPlayer.playCallCount, 0)
    }

    func test_callingPlayNextOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.playNext()

        XCTAssertNil(mockVideoPlayer.lastReplacedItem)
    }

    func test_callingPlayPreviousOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.playPrevious()

        XCTAssertNil(mockVideoPlayer.lastReplacedItem)
    }

    func test_skipToItemOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.skipToItem(at: 3)

        XCTAssertNil(mockVideoPlayer.lastReplacedItem)
    }
}

// MARK: - Helpers

extension VideoQueuePlayerTests {
    @discardableResult private func makeSUT() -> VideoQueuePlayer {
        makeSUT(withItems: 3)
    }

    @discardableResult private func makeSUT(withItems number: Int) -> VideoQueuePlayer {
        let items = testItems(number: number)
        return VideoQueuePlayer(items: items, videoPlayer: mockVideoPlayer)
    }

    @discardableResult private func makeSUT(withItems items: [AVPlayerItem]) -> VideoQueuePlayer {
        VideoQueuePlayer(items: items, videoPlayer: mockVideoPlayer)
    }

    private func testItems(number: Int) -> [AVPlayerItem] {
        assert(number < 9, "Expected a maximum of 8 items.")

        guard number > 0 else { return [] }

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
