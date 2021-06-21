//
//  TransportControlIcons.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 31/01/2021.
//

import Foundation

struct PlayerIcons {
    struct Playback {
        static let play = "play.fill"
        static let pause = "pause.fill"
        static let fastReverse = "backward.fill"
        static let fastForward = "forward.fill"
        static let skipBackwards = "backward.frame.fill"
        static let skipForwards = "forward.frame.fill"
        static let nextItem = "forward.end.fill"
        static let previousItem = "backward.end.fill"
        static let loopPlaylist = "repeat"
        static let loopCurrent = "repeat.1"
        static let close = "xmark"
        static let showPlayerToolbar = "ellipsis.circle"
    }

    struct PlayerOptions {
        static let annotate = "pencil.and.outline"
        static let bookmarks = "bookmark.fill"
        static let settings = "gearshape.fill"
    }
    
    struct BookmarkPanel {
        static let addBookmark = "plus"
        static let nextBookmark = "chevron.down"
        static let previousBookmark = "chevron.up"
        static let startOfBookmark = "backward.end.fill"
        static let endOfBookmark = "forward.end.fill"
        static let loopBookmark = "repeat"
        static let bookmarkHasDrawings = "pencil.and.outline"
    }
}

