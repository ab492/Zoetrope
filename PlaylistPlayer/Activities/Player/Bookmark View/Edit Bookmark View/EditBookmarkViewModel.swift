//
//  EditBookmarkViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 03/04/2021.
//

import Foundation

extension EditBookmarkView {
    class ViewModel: ObservableObject, PlaylistPlayerObserver {

        // MARK: - Properties

        private var playlistPlayer: PlaylistPlayer
        private let selectedBookmark: Video.Bookmark

        /// Here we store a copy of the selected bookmark so we can easily compare
        /// properties to determine if changes have been made in the editor view.
        private let _baseSelectedBookmark: Video.Bookmark

        var timeInLabel: String {
            TimeFormatter.string(from: Int(selectedBookmark.timeIn.seconds))
        }

        var timeOutLabel: String {
            TimeFormatter.string(from: Int(selectedBookmark.timeOut.seconds))
        }

        var changesMade: Bool {
            selectedBookmark.timeIn != _baseSelectedBookmark.timeIn ||
                selectedBookmark.timeOut != _baseSelectedBookmark.timeOut ||
                note != _baseSelectedBookmark.note
        }

        var noteIsEmpty: Bool {
            note == nil
        }

        @Published var note: String?

        // MARK: - Init

        init(playlistPlayer: PlaylistPlayer, selectedBookmark: Video.Bookmark) {
            self.playlistPlayer = playlistPlayer
            self.selectedBookmark = selectedBookmark
            self.note = selectedBookmark.note
            // TODO: Fix this copying!
            self._baseSelectedBookmark = selectedBookmark.copy() as! Video.Bookmark
            self.playlistPlayer.addObserver(self)
        }

        // MARK: - Public

        func setTimeIn() {
            objectWillChange.send()
            selectedBookmark.setTimeIn(playlistPlayer.currentTime)
        }

        func setTimeOut() {
            objectWillChange.send()
            selectedBookmark.setTimeOut(playlistPlayer.currentTime)
        }

        func save() {
            objectWillChange.send()
            selectedBookmark.note = note
            Current.playlistManager.save()
        }

        func reset() {
            objectWillChange.send()
            selectedBookmark.setTimeIn(_baseSelectedBookmark.timeIn)
            selectedBookmark.setTimeOut(_baseSelectedBookmark.timeOut)
            note = _baseSelectedBookmark.note
            selectedBookmark.note = _baseSelectedBookmark.note
        }

        // MARK: - PlaylistPlayerObserver

        internal func playbackPositionDidChange(to time: MediaTime) { }

        internal func playbackDurationDidChange(to time: MediaTime) { }
    }
}
