//
//  PlaylistPlayerTests.swift
//  QueueTetTests
//
//  Created by Andy Brown on 05/01/2021.
//

import XCTest
@testable import VideoQueuePlayer

final class VideoQueuePlayerTests: XCTestCase {

    private var mockVideoPlayer: MockVideoPlayer!

    override func setUp() {
        super.setUp()

        mockVideoPlayer = MockVideoPlayer()
    }

    // MARK: - Init and Basic Functionality

    func test_initialState() {
        let sut = makeSUT()

        sut.nowPlayingIndex.verify(equals: 0)
        sut.loopMode.verify(equals: .playPlaylistOnce)
    }

    func test_playCallsPlay() {
        let sut = makeSUT()

        sut.play()

        mockVideoPlayer.playCallCount.verify(equals: 1)
    }

    func test_callingPlayWithEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: 0)

        sut.play()
        
        mockVideoPlayer.playCallCount.verify(equals: 0)
    }

    func test_playReplacesCurrentItemIfRequired() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.play()

        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[0]).verifyTrue()
    }

    func test_pauseCallsPause() {
        let sut = makeSUT()

        sut.pause()

        mockVideoPlayer.pauseCallCount.verify(equals: 1)
    }

    // MARK: - Play Next Item (Default Loop Mode - Play Playlist Once)

    func test_playNext_incrementsNowPlayingIndexAndReplacesCurrentItem() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.playNext() // Skip to item 2 (index 1)

        sut.nowPlayingIndex.verify(equals: 1)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[1]).verifyTrue()
    }

    func test_itemDidFinishPlayingCallback_incrementsPlayingIndex() {
        let sut = makeSUT()

        sut.nowPlayingIndex.verify(equals: 0)
        sut.currentItemDidFinishPlayback()
        sut.nowPlayingIndex.verify(equals: 1)
    }

    func test_itemDidFinishPlayingCallback_replacesCurrentItem() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.currentItemDidFinishPlayback()

        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[1]).verifyTrue()
    }
    
    func test_playNext_resetsNewItemToZero() {
        let items = testItems(number: 2)
        let sut = makeSUT(withItems: items)

        sut.playNext() // Skip to item 2 (index 1)

        items[1].seekToWasCalled.verifyTrue()
    }

    // MARK: - Play Previous Item (Default Loop Mode - Play Playlist Once)

    func test_playPreviousItem() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.playNext()      // Skip to item 2 (index 1)
        sut.playNext()      // Skip to item 3 (index 2)
        sut.playPrevious()  // Skip to item 2 (index 1)

        sut.nowPlayingIndex.verify(equals: 1)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[1]).verifyTrue()
    }

    func test_playPreviousAtBeginningOfQueue_doesntDecrementNowPlayingIndex() {
        let sut = makeSUT()

        sut.playPrevious()

        sut.nowPlayingIndex.verify(equals: 0)
    }

    func test_playPreviousItemAtBeginning_seeksToZero() {
        let sut = makeSUT()

        sut.playPrevious()

        mockVideoPlayer.seekToTimeCalledCount.verify(equals: 1)
    }
    
    func test_playPrevious_resetsNewItemToZero() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.playNext()      // Skip to item 2 (index 1)
        sut.playNext()      // Skip to item 3 (index 2)
        sut.playPrevious()  // Skip to item 2 (index 1)

        items[1].seekToWasCalled.verifyTrue()
    }

    // MARK: - Looping Whole Playlist

    func test_loopWholePlaylist_loopsBackToBeginningAtEndOfQueue() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.loopMode = .loopPlaylist

        sut.playNext() // Skip to item 2 (index 1)
        sut.playNext() // Skip to item 3 (index 2)
        sut.playNext() // Loop back around to item 1 (index 0)

        sut.nowPlayingIndex.verify(equals: 0)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[0]).verifyTrue()
    }

    func test_loopWholePlaylist_indexBackToBeginningOnItemDidFinish() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopPlaylist
        sut.playNext()
        sut.playNext() // Last item in playlist

        sut.currentItemDidFinishPlayback()

        sut.nowPlayingIndex.verify(equals: 0)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[0]).verifyTrue()
    }

    func test_loopWholePlaylist_playPreviousAtBeginningOfQueue_loopsBackwardsToLastItem() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopPlaylist

        sut.playPrevious()

        sut.nowPlayingIndex.verify(equals: 2)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[2]).verifyTrue()
    }

    // MARK: - Playing Playlist Once

    func test_playNextAtEndOfQueue_doesntIncrementNowPlayingIndex() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .playPlaylistOnce
        sut.playNext() // Skip to item 2 (index 1)
        sut.playNext() // Skip to item 3 (index 2) - end of playlist

        sut.playNext()

        sut.nowPlayingIndex.verify(equals: 2)
    }

    func test_playOnce_doesntIncrementOnItemDidFinish() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .playPlaylistOnce
        sut.playNext() // Skip to item 2 (index 1)
        sut.playNext() // Skip to item 3 (index 2) - end of playlist

        sut.currentItemDidFinishPlayback()

        sut.nowPlayingIndex.verify(equals: 2)
    }

    // MARK: - Loop Current

    func test_loopCurrent_playNextIncrementsNowPlayingIndex() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .loopCurrent

        sut.playNext() // Start looping item 2 (index 1)
        sut.playNext() // Start looping item 3 (index 2)

        sut.nowPlayingIndex.verify(equals: 2)
    }

    func test_loopCurrent_doesntIncrementOnItemDidFinish() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopCurrent

        sut.playNext() // Start looping item 2 (index 1)
        sut.currentItemDidFinishPlayback()

        sut.nowPlayingIndex.verify(equals: 1)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[1]).verifyTrue()
    }

    func test_playNextWithLoopCurrent_doesntIncrementOnceAtEndOfQueue() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopCurrent

        sut.playNext() // Start looping item 2 (index 1)
        sut.playNext() // Start looping item 3 (index 2) - end of playlist
        sut.playNext() // Loop back around to item 1 (index 0)

        sut.nowPlayingIndex.verify(equals: 0)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[0]).verifyTrue()
    }

    func test_loopCurrent_playPreviousAtBeginningOfQueue_loopsBackwardsToLastItem() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        sut.loopMode = .loopCurrent

        sut.playPrevious()

        sut.nowPlayingIndex.verify(equals: 2)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[2]).verifyTrue()
    }

    // MARK: - Skip to Specific Index

    func test_skipToIndex_worksCorrectly() throws {
        let items = testItems(number: 8)
        let sut = makeSUT(withItems: items)

        sut.skipToItem(at: 3)

        sut.nowPlayingIndex.verify(equals: 3)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[3]).verifyTrue()
    }

    func test_skipToIndexWithNegative_defaultsTo0() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.skipToItem(at: -1)

        sut.nowPlayingIndex.verify(equals: 0)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[0]).verifyTrue()
    }

    func test_skipToIndexWithNegative_defaultsToMax() throws {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.skipToItem(at: 5)

        sut.nowPlayingIndex.verify(equals: 2)
        try mockVideoPlayer.lastReplacedItem.assertUnwrap().isSame(as: items[2]).verifyTrue()
    }

    // MARK: - Replacing Queue

    func test_replacingQueueWorksCorrectly() {
        let items = testItems(number: 8)
        let sut = makeSUT(withItems: items)

        let newItems = testItems(number: 3)
        sut.replaceQueue(with: newItems)

        sut.nowPlayingIndex.verify(equals: 0)
    }

    // MARK: - Seeking

    func test_seekingCorrectlyPreservesMediaTime() throws {
        let sut = makeSUT(withItems: 1)

        sut.seek(to: MediaTime(seconds: 1.7653))

        try mockVideoPlayer.lastSeekedToTime.assertUnwrap().verify(equals: MediaTime(seconds: 1.7653))
    }


    // MARK: - Empty Playlist Behavior

    func test_callingPlayOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.play()

        mockVideoPlayer.playCallCount.verify(equals: 0)
    }

    func test_callingPauseOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.pause()

        mockVideoPlayer.playCallCount.verify(equals: 0)
    }

    func test_callingPlayNextOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.playNext()

        mockVideoPlayer.lastReplacedItem.verifyNil()
    }

    func test_callingPlayPreviousOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.playPrevious()

        mockVideoPlayer.lastReplacedItem.verifyNil()
    }

    func test_skipToItemOnEmptyPlaylist_doesNothing() {
        let sut = makeSUT(withItems: [])

        sut.skipToItem(at: 3)

        mockVideoPlayer.lastReplacedItem.verifyNil()
    }

    // MARK: - Playback Rate

    func test_playbackRate_isSetCorrectly() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)

        sut.playbackRate = 1.5

        sut.playbackRate.verify(equals: 1.5)
        mockVideoPlayer.playbackRate.verify(equals: 1.5)
    }

    func test_playbackRate_isFetchedCorrectly() {
        let items = testItems(number: 3)
        let sut = makeSUT(withItems: items)
        mockVideoPlayer.playbackRate = 1.75

        sut.playbackRate.verify(equals: 1.75)
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

    @discardableResult private func makeSUT(withItems items: [MockPlayerItem]) -> VideoQueuePlayer {
        VideoQueuePlayer(items: items, videoPlayer: mockVideoPlayer)
    }

    private func testItems(number: Int) -> [MockPlayerItem] {
        guard number > 0 else { return [] }
        
        return (0...number - 1)
            .compactMap { URL(string: "path/to/file/\($0).mov") }
            .map { MockPlayerItem(url: $0) }
    }
}

// MARK: - Types

private class MockPlayerItem: PlayerItem {
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var seekToWasCalled = false
    func seek(to time: MediaTime) {
        seekToWasCalled = true
    }
    
    func isSame(as other: PlayerItem) -> Bool {
        url == other.url
    }
}
