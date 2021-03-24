//
//  PlaylistDetailViewModelTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 13/03/2021.
//

import XCTest
@testable import PlaylistPlayer

class PlaylistDetailViewModelTests: BaseTestCase {

    var video1: Video!
    var video2: Video!
    var playlist: Playlist!

    override func setUp() {
        super.setUp()

        video1 = VideoBuilder().filename("my-first-test-video.mov").duration(Time(seconds: 24)).build()
        video2 = VideoBuilder().filename("my-second-test-video.mov").duration(Time(seconds: 91)).build()
        playlist = PlaylistBuilder().name("Test Playlist").videos([video1, video2]).build()
    }

    func test_initViewModel_addsObserverToPlaylistManager() {
        makeSUT(playlist: playlist)

        XCTAssertEqual(Current.mockPlaylistManager.addObserverCallCount, 1)
    }

    // The default is descending, meaning the button will show ascending.
    func test_defaultSortByTitleOrder_isDescending() {
        let sut = makeSUT(playlist: playlist)

        XCTAssertEqual(sut.sortByTitleSortOrder, .descending)
    }

    func test_updatingSortByTitleOrder_callsSaveOnPlaylistManager() {
        let sut = makeSUT(playlist: playlist)

        sut.sortByTitleSortOrder = .ascending

        XCTAssertEqual(Current.mockPlaylistManager.saveCallCount, 1)
    }

    // TODO: Test for videos actually being sorted

    @discardableResult private func makeSUT(playlist: Playlist) -> PlaylistDetailView.ViewModel {
        PlaylistDetailView.ViewModel(playlist: playlist)
    }
}
