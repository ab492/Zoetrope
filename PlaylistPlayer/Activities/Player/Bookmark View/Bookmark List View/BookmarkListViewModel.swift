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
                // Here we use a buffer time (+/- 0.1 seconds) to make up for the fact that the
                // player doesn't report an update every single frame (which causes some current
                // bookmarks to flicker).
                let adjustedTimeIn = bookmark.timeIn.seconds - 0.1
                let adjustedTimeOut = bookmark.timeOut.seconds + 0.1

                let bookmarkRange = adjustedTimeIn...adjustedTimeOut
                if bookmarkRange.contains(playlistPlayer.currentTime.seconds) {
                    currentBookmarks.append(bookmark)
                }
            }
            return currentBookmarks
        }

        var bookmarkOnLoop: Video.Bookmark? {
            willSet {
                objectWillChange.send()
            }
            didSet {
                guard let bookmark = bookmarkOnLoop else { return }
                playlistPlayer.seek(to: bookmark.timeIn)
            }
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

        func formattedTimeForBookmark(_ bookmark: Video.Bookmark) -> String {
            if bookmark.isOneFrameLong {
                // If the bookmark is only one frame, just return the timeIn (00:23)
                return TimeFormatter.string(from: Int(bookmark.timeIn.seconds))
            } else {
                // Otherwise return timeIn-timeOut (00:23-00:40)
                return "\(TimeFormatter.string(from: Int(bookmark.timeIn.seconds)))-\(TimeFormatter.string(from: Int(bookmark.timeOut.seconds)))"
            }
        }

        func formattedNoteForBookmark(_ bookmark: Video.Bookmark) -> String {
            bookmark.note ?? "No Note"
        }

        func goToStartOfBookmark(_ bookmark: Video.Bookmark) {
            objectWillChange.send()
            playlistPlayer.seek(to: bookmark.timeIn)
        }

        func goToEndOfBookmark(_ bookmark: Video.Bookmark) {
            objectWillChange.send()
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
                let bookmarkToRemove = bookmarks[index]
                currentVideo.removeBookmark(bookmarkToRemove)
                if bookmarkOnLoop == bookmarkToRemove {
                    bookmarkOnLoop = nil
                }
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

            // Bookmark Looping Behaviour
            guard let loopingBookmark = bookmarkOnLoop else { return }
            
            if abs(time.seconds - loopingBookmark.timeOut.seconds) < 0.1 {
                playlistPlayer.seek(to: loopingBookmark.timeIn)
            }
        }

        func playbackDurationDidChange(to time: MediaTime) {
            objectWillChange.send()
            bookmarkOnLoop = nil
        }
    }
}
