//
//  PlaylistPlayerTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 27/03/2021.
//

import XCTest
import VideoQueuePlayer
@testable import Zoetrope

class PlaylistPlayerTests: BaseTestCase {

    var mockVideoQueuePlayer: MockVideoQueuePlayer!
    var testObserver: TestPlaylistPlayerObserver!

    override func setUp() {
        super.setUp()

        mockVideoQueuePlayer = MockVideoQueuePlayer()
        testObserver = TestPlaylistPlayerObserver()
    }

    // MARK: - Currently Playing Video

    func test_currentlyPlayingVideo_isCorrectlyReported() {
        let video1 = VideoBuilder().build()
        let video2 = VideoBuilder().build()
        given_nowPlayingIndexIs(index: 1)

        let sut = makeSUT_andQueueVideos([video1, video2])

        XCTAssertEqual(sut.currentlyPlayingVideo, video2)
    }

    func test_noPlaylist_currentlyPlayingVideoIsNil() {
        let sut = makeSUT()

        XCTAssertNil(sut.currentlyPlayingVideo)
    }


    // MARK: - Updating Loop Mode
// TODO: Fix this!
//    func test_init_setsPlayerLoopModeToSameAsUserPreferences() {
//        Current.mockUserPreferencesManager.loopMode = .loopCurrent
//
//        let sut = makeSUT()
//
//        XCTAssertEqual(sut.loopMode, .loopCurrent)
//    }

    func test_updatingLoopMode_notifiesPlaylistPlayer() {
        let sut = makeSUT()

        sut.loopMode = .loopCurrent

        XCTAssertEqual(mockVideoQueuePlayer.lastSelectedLoopMode, .loopCurrent)
    }

    func test_updatingLoopMode_updatesUserPreferences() {
        let sut = makeSUT()

        sut.loopMode = .loopCurrent

        XCTAssertEqual(Current.mockUserPreferencesManager.lastUpdatedLoopMode, .loopCurrent)
    }
    
    // MARK: - Helpers

    @discardableResult func makeSUT() -> PlaylistPlayerImpl {
        let player = PlaylistPlayerImpl(videoQueuePlayer: mockVideoQueuePlayer)
        player.addObserver(testObserver)
        return player
    }

    func makeSUT_andQueueVideos(_ videos: [VideoModel]) -> PlaylistPlayerImpl {
        let playlist = PlaylistBuilder().videos(videos).build()

        let sut = makeSUT()
        sut.onAppServicesLoaded()
        sut.updateQueue(for: playlist)

        return sut
    }

    // MARK: - Givens

    func given_nowPlayingIndexIs(index: Int) {
        mockVideoQueuePlayer.nowPlayingIndex = index
    }
}
