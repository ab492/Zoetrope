//
//  MockPlaylistPlayer.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 12/03/2021.
//

import Foundation
import AVFoundation
@testable import PlaylistPlayer

final class MockPlaylistPlayer: PlaylistPlayerProtocol {

    var lastSelectedLoopMode: LoopMode?
    var loopMode: LoopMode = .playPlaylistOnce {
        didSet {
            lastSelectedLoopMode = loopMode
        }
    }

    var playNextCallCount = 0
    func playNext() {
        playNextCallCount += 1
    }

    var playPreviousCallCount = 0
    func playPrevious() {
        playPreviousCallCount += 1
    }

    var replaceQueueWasCalled = false
    func replaceQueue(with items: [AVPlayerItem]) {
        replaceQueueWasCalled = true
    }

    var nowPlayingIndex: Int = 0
    
    func play() {
        fatalError("Not implemented")
    }

    func pause() {
        fatalError("Not implemented")
    }

    func skipToItem(at index: Int) {
        fatalError("Not implemented")
    }

    func step(byFrames count: Int) {
        fatalError("Not implemented")
    }

    func seek(to time: MediaTime) {
        fatalError("Not implemented")
    }

    func scrubbingDidStart() {
        fatalError("Not implemented")
    }

    func scrubbed(to time: MediaTime) {
        fatalError("Not implemented")
    }

    func scrubbingDidEnd() {
        fatalError("Not implemented")
    }

    func playFastForward() {
        fatalError("Not implemented")
    }

    func playFastBackward() {
        fatalError("Not implemented")
    }

    var currentItemDuration: MediaTime = .zero

    var volume: Float = 1

    var observer: PlaylistPlayerObserver?

}
