//
//  BookmarkEditorViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 21/03/2021.
//

import Foundation

extension BookmarkEditorView {
    class ViewModel: ObservableObject {

        // TODO: Find a nicer way to save on exit.

        // MARK: - Properties

        private let playlistPlayer: PlaylistPlayerViewModelProtocol

        var bookmarks: [Video.Bookmark] {
            playlistPlayer.currentlyPlayingVideo?.bookmarks ?? []
        }

        /// Represents the currently active bookmarks (i.e. if the playhead is within the start/end of a bookmark).
        var currentBookmarks: [Video.Bookmark] {
            let currentTime = playlistPlayer.currentTime
            var currentBookmarks = [Video.Bookmark]()
            for bookmark in bookmarks {
                let bookmarkRange = bookmark.timeIn...bookmark.timeOut
                if bookmarkRange.contains(currentTime) {
                    currentBookmarks.append(bookmark)
                }
            }
            return currentBookmarks
        }

        // MARK: - Init

        init(playlistPlayer: PlaylistPlayerViewModelProtocol) {
            self.playlistPlayer = playlistPlayer
        }

        // MARK: - Public

        func addBookmark() {
            objectWillChange.send()
            guard let currentVideo = playlistPlayer.currentlyPlayingVideo else { return }
            let bookmark = Video.Bookmark(id: UUID(),
                                          timeIn: playlistPlayer.currentTime,
                                          timeOut: playlistPlayer.currentTime,
                                          noteType: .text("Test note"))
            currentVideo.addBookmark(bookmark)
            Current.playlistManager.save()
        }

        func formattedTimeInForBookmark(_ bookmark: Video.Bookmark) -> String {
            TimeFormatter.string(from: Int(bookmark.timeIn.seconds))
        }

        func formattedTimeOutForBookmark(_ bookmark: Video.Bookmark) -> String {
            // TODO: How to format doubles?
            TimeFormatter.string(from: Int(bookmark.timeOut.seconds))
        }

        func setStartOfBookmark(_ bookmark: Video.Bookmark) {
            objectWillChange.send()
            bookmark.setTimeIn(playlistPlayer.currentTime)
            Current.playlistManager.save()
        }

        func goToStartOfBookmark(_ bookmark: Video.Bookmark) {
            playlistPlayer.seek(to: bookmark.timeIn)
            Current.playlistManager.save()
        }

        func setEndOfBookmark(_ bookmark: Video.Bookmark) {
            objectWillChange.send()
            bookmark.setTimeOut(playlistPlayer.currentTime)
            Current.playlistManager.save()
        }

        func goToEndOfBookmark(_ bookmark: Video.Bookmark) {
            playlistPlayer.seek(to: bookmark.timeOut)
            Current.playlistManager.save()
        }

        func nextBookmark() {
            guard let next = bookmarks.first(where: { $0.timeIn > playlistPlayer.currentTime }) else { return }
            playlistPlayer.seek(to: next.timeIn)



//            var nextBookmark: Video.Bookmark?
//
//            if let latestCurrentBookmark = currentBookmarks.last,
//               let indexOfLatestCurrentBookmark = bookmarks.firstIndex(of: latestCurrentBookmark) {
//                // If we're on a bookmark, find the next one...
//                print("CAME FROM BOOKMARK")
//                nextBookmark = bookmarks[maybe: indexOfLatestCurrentBookmark + 1]
//            } else {
//                // Otherwise, find the closest bookmark...
//                print("CAME FROM NOWHERE: \(playlistPlayer.currentTime)")
//
//                nextBookmark = bookmarks.first(where: { $0.timeIn > playlistPlayer.currentTime })
//                print("NEXT BOOKMARK?: \(nextBookmark?.timeIn)")
//            }
//
//            guard let next = nextBookmark else { return }
//            playlistPlayer.seek(to: next.timeIn)
        }

        func previousBookmark() {
            guard let previous = bookmarks.last(where: { $0.timeIn < playlistPlayer.currentTime }) else { return }
            playlistPlayer.seek(to: previous.timeIn)

        }
    }
}
