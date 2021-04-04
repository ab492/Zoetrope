//
//  EditBookmarkViewModelTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 04/04/2021.
//

import XCTest
@testable import PlaylistPlayer

final class EditBookmarkViewModelTests: BaseTestCase {

    // MARK: - Properties and Setup

    private var mockPlaylistPlayer: MockPlaylistPlayer!
    private var selectedBookmark: Video.Bookmark!

    override func setUp() {
        super.setUp()

        mockPlaylistPlayer = MockPlaylistPlayer()
        selectedBookmark = Video.Bookmark(id: UUID(), timeIn: MediaTime(seconds: 10), timeOut: MediaTime(seconds: 20))
    }

    // MARK: - Tests
    
    func test_timeInAndOut_areFormattedCorrectly() {
        let sut = makeSUT()

        XCTAssertEqual(sut.timeInLabel, "00:10")
        XCTAssertEqual(sut.timeOutLabel, "00:20")
    }

    func test_settingStartPoint() {
        let sut = makeSUT()
        given_playerHasCurrentTime(seconds: 15)

        sut.setTimeIn()

        XCTAssertEqual(selectedBookmark.timeIn, MediaTime(seconds: 15))
    }

    func test_settingEndPoint() {
        let sut = makeSUT()
        given_playerHasCurrentTime(seconds: 15)

        sut.setTimeOut()

        XCTAssertEqual(selectedBookmark.timeOut, MediaTime(seconds: 15))
    }

    func test_initialNoteIsCorrectlyReported_whenPresent() {
        given_selectedBookmarkHasNote("This is a test note")
        let sut = makeSUT()

        XCTAssertEqual(sut.note, "This is a test note")
    }

    func test_initialNoteIsCorrectlyReported_whenNotPresent() {
        given_selectedBookmarkHasNote(nil)
        let sut = makeSUT()

        XCTAssertNil(sut.note)
    }

    // MARK: - Changes Made

    func test_initialState_reportsNoChangesMade() {
        let sut = makeSUT()

        XCTAssertEqual(sut.changesMade, false)
    }

    func test_editingNote_reportsAsChangesMade() {
        let sut = makeSUT()

        XCTAssertEqual(sut.changesMade, false)
        sut.note = "This is an updated note"

        XCTAssertEqual(sut.changesMade, true)
    }

    func test_updatingTimeIn_reportsAsChangesMade() {
        let sut = makeSUT()
        given_playerHasCurrentTime(seconds: 15)

        XCTAssertEqual(sut.changesMade, false)
        sut.setTimeIn()

        XCTAssertEqual(sut.changesMade, true)
    }

    func test_updatingTimeOut_reportsAsChangesMade() {
        let sut = makeSUT()
        given_playerHasCurrentTime(seconds: 15)

        XCTAssertEqual(sut.changesMade, false)
        sut.setTimeOut()

        XCTAssertEqual(sut.changesMade, true)
    }

    // MARK: - Saving

    func test_callingSave_correctlyUpdatesSelectedBookmark() {
        let sut = makeSUT()

        // Simulate making various changes

        given_playerHasCurrentTime(seconds: 15)
        sut.setTimeIn()

        given_playerHasCurrentTime(seconds: 17)
        sut.setTimeOut()

        sut.note = "This is a new note"

        sut.save()

        XCTAssertEqual(selectedBookmark.note, "This is a new note")
        XCTAssertEqual(selectedBookmark.timeIn, MediaTime(seconds: 15))
        XCTAssertEqual(selectedBookmark.timeOut, MediaTime(seconds: 17))
    }

    func test_callingSave_callsSaveOnPlaylistManager() {
        let sut = makeSUT()

        sut.note = "Updated note"
        sut.save()

        XCTAssertEqual(Current.mockPlaylistManager.saveCallCount, 1)
    }

    // MARK: - Resetting

    func test_makingChangesThenCallingReset_resetsBookmarkToInitialState() {
        given_selectedBookmarkHasNote("This is an initial note.")
        let sut = makeSUT()

        // Simulate making various changes
        given_playerHasCurrentTime(seconds: 15)
        sut.setTimeIn()

        given_playerHasCurrentTime(seconds: 17)
        sut.setTimeOut()

        sut.note = "This is a new note"

        // Reset bookmark
        sut.reset()

        XCTAssertEqual(selectedBookmark.note, "This is an initial note.")
        XCTAssertEqual(sut.note, "This is an initial note.")
        XCTAssertEqual(selectedBookmark.timeIn, MediaTime(seconds: 10))
        XCTAssertEqual(selectedBookmark.timeOut, MediaTime(seconds: 20))
    }
}

// MARK: - MakeSUT and Givens

extension EditBookmarkViewModelTests {
    func makeSUT() -> EditBookmarkView.ViewModel {
        EditBookmarkView.ViewModel(playlistPlayer: mockPlaylistPlayer, selectedBookmark: selectedBookmark)
    }

    func given_playerHasCurrentTime(seconds: Double) {
        mockPlaylistPlayer.currentTime = MediaTime(seconds: seconds)
    }

    func given_selectedBookmarkHasNote(_ note: String?) {
        selectedBookmark.note = note
    }
}

