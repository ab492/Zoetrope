//
//  MockPlaylistPlayer.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 04/04/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockPlaylistPlayer: PlaylistPlayer {

    var lastSeekedToTime: MediaTime?
    func seek(to time: MediaTime) {
        lastSeekedToTime = time
    }

    var currentlyPlayingVideo: Video?

    var playbackRate: Float = 1

    var isPlaying: Bool = true

    var isReadyForPlayback: Bool = true

    var canPlayFastReverse: Bool = true

    var canPlayFastForward: Bool = true

    var currentTime: MediaTime = .zero

    var duration: MediaTime = .zero


    var loopMode: LoopMode = .loopCurrent

    func play() {
        fatalError("Not implemented")
    }

    func pause() {
        fatalError("Not implemented")
    }

    func nextItem() {
        fatalError("Not implemented")
    }

    func previousItem() {
        fatalError("Not implemented")
    }

    func skipToItem(at index: Int) {
        fatalError("Not implemented")
    }

    func step(byFrames frames: Int) {
        fatalError("Not implemented")
    }

    func updateQueue(for playlist: Playlist) {
        fatalError("Not implemented")
    }

    func scrubbingDidStart() {
        fatalError("Not implemented")
    }

    func scrubbingDidEnd() {
        fatalError("Not implemented")
    }

    func scrubbed(to time: MediaTime) {
        fatalError("Not implemented")
    }

    func playFastForward() {
        fatalError("Not implemented")
    }

    func playFastReverse() {
        fatalError("Not implemented")
    }

    func setVideoPlayer(view: PlayerView) {
        fatalError("Not implemented")
    }

    // MARK: - Observers

    var observations = [ObjectIdentifier : WeakBox<PlaylistPlayerObserver>]()

    func addObserver(_ observer: PlaylistPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = WeakBox(observer)
    }

    func removeObserver(_ observer: PlaylistPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
