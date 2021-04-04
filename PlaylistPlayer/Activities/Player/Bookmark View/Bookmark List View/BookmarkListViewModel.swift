//
//  BookmarkListViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 03/04/2021.
//

import Foundation

extension BookmarkListView {

    class ViewModel: ObservableObject, PlaylistPlayerObserver {

        // MARK: - Properties

        private var playlistPlayer: PlaylistPlayer

        var bookmarks: [Video.Bookmark] {
            playlistPlayer.currentlyPlayingVideo?.bookmarks ?? []
        }

        /// Represents the currently active bookmarks (i.e. if the playhead is within the start/end of a bookmark).
        var currentBookmarks: [Video.Bookmark] {
            var currentBookmarks = [Video.Bookmark]()
            for bookmark in bookmarks {
                let bookmarkRange = bookmark.timeIn...bookmark.timeOut
                if bookmarkRange.contains(playlistPlayer.currentTime) {
                    currentBookmarks.append(bookmark)
                }
            }
            return currentBookmarks
        }

        // Internal variable kept to track when the current bookmarks actually change. Only
        // at that point will we notify observers. This prevents `objectWillChange` being
        // sent on every frame update as that causes slow animations.
        private var _currentBookmarks: [Video.Bookmark] = [] {
            didSet {
                guard _currentBookmarks != oldValue else { return }
                objectWillChange.send()
            }
        }

        // MARK: - Init

        init(playlistPlayer: PlaylistPlayer) {
            self.playlistPlayer = playlistPlayer
            self.playlistPlayer.addObserver(self)
        }

        // MARK: - Public

        func formattedTimeInForBookmark(_ bookmark: Video.Bookmark) -> String {
            TimeFormatter.string(from: Int(bookmark.timeIn.seconds))
        }

        func formattedTimeOutForBookmark(_ bookmark: Video.Bookmark) -> String {
            // TODO: How to format doubles?
            TimeFormatter.string(from: Int(bookmark.timeOut.seconds))
        }

        func goToStartOfBookmark(_ bookmark: Video.Bookmark) {
            playlistPlayer.seek(to: bookmark.timeIn)
        }

        func goToEndOfBookmark(_ bookmark: Video.Bookmark) {
            playlistPlayer.seek(to: bookmark.timeOut)
        }

        func nextBookmark() {
            // TODO: Need to handle current bookmarks here.
            guard let next = bookmarks.first(where: { $0.timeIn > playlistPlayer.currentTime }) else { return }
            playlistPlayer.seek(to: next.timeIn)
        }

        func previousBookmark() {
            // TODO: Need to handle current bookmarks here.
            guard let previous = bookmarks.last(where: { $0.timeIn < playlistPlayer.currentTime }) else { return }
            playlistPlayer.seek(to: previous.timeIn)
        }

        func addBookmark() {
            objectWillChange.send()
            guard let currentVideo = playlistPlayer.currentlyPlayingVideo else { return }
            let bookmark = Video.Bookmark(id: UUID(),
                                          timeIn: playlistPlayer.currentTime,
                                          timeOut: playlistPlayer.currentTime)
            currentVideo.addBookmark(bookmark)
            Current.playlistManager.save()
        }

        func remove(bookmarksAt indexSet: IndexSet) {
            objectWillChange.send()
            guard let currentVideo = playlistPlayer.currentlyPlayingVideo else { return }

            let indexes = Array(indexSet)
            for index in indexes.reversed() {
                currentVideo.removeBookmark(bookmarks[index])
            }

            Current.playlistManager.save()
        }

        func editBookmarkViewModel(for selectedBookmark: Video.Bookmark) -> EditBookmarkView.ViewModel {
            EditBookmarkView.ViewModel(playlistPlayer: playlistPlayer, selectedBookmark: selectedBookmark)
        }

        // MARK: - PlaylistPlayerObserver

        func playbackPositionDidChange(to time: MediaTime) {
            // Here we use an internal variable to track when the current bookmarks actually
            // change. This prevents `objectWillChange` being sent on every frame update as
            // that causes slow animation.
            _currentBookmarks = currentBookmarks
        }

        func playbackDurationDidChange(to time: MediaTime) {
            objectWillChange.send()
        }
    }
}
