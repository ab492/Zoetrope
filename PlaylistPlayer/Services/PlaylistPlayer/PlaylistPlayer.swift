//
//  PlaylistPlayer.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 27/03/2021.
//

import Foundation

enum PlayPauseState {
    case playing
    case paused
}

protocol PlaylistPlayer {

    // Player Information
    var isPlaying: Bool { get }
    var isReadyForPlayback: Bool { get }
    var canPlayFastReverse: Bool { get }
    var canPlayFastForward: Bool { get }
    var currentTime: MediaTime { get }
    var duration: MediaTime { get }
    var currentlyPlayingVideo: Video? { get }
    var loopMode: LoopMode { get set }
    var playbackRate: Float { get set }
    
    // Player Actions
    func play()
    func pause()
    func nextItem()
    func previousItem()
    func skipToItem(at index: Int)
    func step(byFrames frames: Int)
    func seek(to time: MediaTime)
    func updateQueue(for playlist: Playlist)
    func scrubbingDidStart()
    func scrubbingDidEnd()
    func scrubbed(to time: MediaTime)
    func playFastForward()
    func playFastReverse()

    // PlayerView
    func setVideoPlayer(view: PlayerView)
    
    // Observable
    var observations: [ObjectIdentifier: WeakBox<PlaylistPlayerObserver>] { get set }
    func addObserver(_ observer: PlaylistPlayerObserver)
    func removeObserver(_ observer: PlaylistPlayerObserver)
}

protocol PlaylistPlayerObserver: AnyObject {
    func loopModeDidUpdate(newValue: LoopMode)
    func playbackStateDidChange(to: PlayPauseState)
    func playbackReadinessDidChange(isReady: Bool)
    func playbackFastReverseAbilityDidChange(canPlayFastReverse: Bool)
    func playbackFastForwardAbilityDidChange(canPlayFastForward: Bool)
    func playbackPositionDidChange(to time: MediaTime)
    func playbackDurationDidChange(to time: MediaTime)
}

extension PlaylistPlayerObserver {
    func loopModeDidUpdate(newValue: LoopMode) { }
    func playbackStateDidChange(to: PlayPauseState) { }
    func playbackReadinessDidChange(isReady: Bool) { }
    func playbackFastReverseAbilityDidChange(canPlayFastReverse: Bool) { }
    func playbackFastForwardAbilityDidChange(canPlayFastForward: Bool) { }
    func playbackPositionDidChange(to time: MediaTime) { }
    func playbackDurationDidChange(to time: MediaTime) { }
}

