//
//  PlaylistPlayerTests.swift
//  QueueTetTests
//
//  Created by Andy Brown on 05/01/2021.
//

import XCTest
import AVFoundation
@testable import PlaylistPlayer

final class PlaylistPlayerTests: XCTestCase {

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

    func test_initQueuesGivenItems() {
        let items = testItems(number: 3)
        makeSUT(withItems: items)

        XCTAssertEqual(mockVideoPlayer.queuedItems!, items)
    }

    func test_Play_CallsPlay() {
        let sut = makeSUT()

        sut.play()

        XCTAssertEqual(mockVideoPlayer.playCallCount, 1)
    }

    func test_pause_CallsPause() {
        let sut = makeSUT()

        sut.pause()

        XCTAssertEqual(mockVideoPlayer.pauseCallCount, 1)
    }

    // MARK: - Play Next Item

    func test_playNext_callsAdvanceToNextItem() {
        let sut = makeSUT()

        sut.playNext()

        XCTAssertEqual(mockVideoPlayer.advanceToNextItemCalledCount, 1)
    }

    func test_playNext_incrementsNowPlayingIndex() {
        let sut = makeSUT()

        sut.playNext()

        XCTAssertEqual(sut.nowPlayingIndex, 1)
    }

    func test_itemDidFinishPlayingCallback_incrementsPlayingIndex() {
        let sut = makeSUT()

        XCTAssertEqual(sut.nowPlayingIndex, 0)
        sut.currentItemDidFinishPlayback()
        XCTAssertEqual(sut.nowPlayingIndex, 1)
    }

    // MARK: - Play Previous Item

    func test_playPreviousItem() {
        let sut = makeSUT(withItems: 3)

        sut.playNext()
        sut.playNext()
        sut.playPrevious()

        XCTAssertEqual(sut.nowPlayingIndex, 1)
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
        let sut = makeSUT(withItems: 3)

        sut.loopMode = .loopPlaylist

        sut.playNext() // nowPlayingIndex = 1
        sut.playNext() // nowPlayingIndex = 2
        sut.playNext() // loop back around to 0

        XCTAssertEqual(sut.nowPlayingIndex, 0)
    }

    func test_loopWholePlaylist_indexBackToBeginningOnItemDidFinish() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .loopPlaylist
        sut.playNext()
        sut.playNext() // last item in playlist

        sut.currentItemDidFinishPlayback()

        XCTAssertEqual(sut.nowPlayingIndex, 0)
    }

    // MARK: - Playing Playlist Once

    func test_playNextAtEndOfQueue_doesntIncrementNowPlayingIndex() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .playPlaylistOnce

        sut.playNext() // nowPlayingIndex = 1
        sut.playNext() // nowPlayingIndex = 2
        sut.playNext() // end of playlist

        XCTAssertEqual(sut.nowPlayingIndex, 2)
    }

    func test_playOnce_doesntIncrementOnItemDidFinish() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .playPlaylistOnce
        sut.playNext()
        sut.playNext() // last item in playlist

        sut.currentItemDidFinishPlayback()

        XCTAssertEqual(sut.nowPlayingIndex, 2)
    }

    // MARK: - Loop Current

    func test_loopCurrent_playNextDoesntIncrementNowPlayingIndex() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .loopCurrent

        sut.playNext()
        sut.playNext()

        XCTAssertEqual(sut.nowPlayingIndex, 2)
    }

    func test_loopCurrent_doesntIncrementOnItemDidFinish() {
        let sut = makeSUT(withItems: 3)
        sut.loopMode = .loopCurrent

        sut.playNext()
        sut.currentItemDidFinishPlayback()

        XCTAssertEqual(sut.nowPlayingIndex, 1)
    }

    // MARK: - Skip to Specific Index

    func test_skipToIndex_worksCorrectly() {
        let sut = makeSUT(withItems: 8)

        sut.skipToItem(at: 3)

        XCTAssertEqual(sut.nowPlayingIndex, 3)
    }

    func test_skipToIndexWithNegative_defaultsTo0() {
        let sut = makeSUT(withItems: 3)

        sut.skipToItem(at: -1)

        XCTAssertEqual(sut.nowPlayingIndex, 0)
    }

    func test_skipToIndexWithNegative_defaultsToMax() {
        let sut = makeSUT(withItems: 3)

        sut.skipToItem(at: 5)

        XCTAssertEqual(sut.nowPlayingIndex, 2)
    }
}

// MARK: - Helpers

extension PlaylistPlayerTests {
    @discardableResult private func makeSUT() -> PlaylistPlayer {
        makeSUT(withItems: 3)
    }

    @discardableResult private func makeSUT(withItems number: Int) -> PlaylistPlayer {
        let items = testItems(number: number)
        return PlaylistPlayer(items: items, videoPlayer: mockVideoPlayer)
    }

    @discardableResult private func makeSUT(withItems items: [AVPlayerItem]) -> PlaylistPlayer {
        PlaylistPlayer(items: items, videoPlayer: mockVideoPlayer)
    }

    private func testItems(number: Int) -> [AVPlayerItem] {
        assert(number < 9, "Expected a maximum of 8 items.")

        let testBundle = Bundle(for: type(of: self))

        let avItems = ["01", "02", "03", "04", "05", "06", "07", "08"]
            .compactMap { testBundle.url(forResource: $0, withExtension: "mov") }
            .map { AVPlayerItem(url: $0) }

        assert(avItems.count == 8, "Expected 8 movs in bundle to correctly create test items.")

        var itemsToReturn = [AVPlayerItem]()

        for index in 0...number - 1  {
            itemsToReturn.append(avItems[index])
        }
        return itemsToReturn
    }
}


