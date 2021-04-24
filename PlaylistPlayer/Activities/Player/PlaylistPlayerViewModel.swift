//
//  PlayerViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import AVFoundation
import SwiftUI

final class PlaylistPlayerViewModel: ObservableObject {

    // MARK: - Properties
    
    private var playlistPlayer: PlaylistPlayer

    @Published private(set) var isPlaying = false
    @Published private(set) var isReadyForPlayback = false
    @Published private(set) var canPlayFastReverse = false
    @Published private(set) var canPlayFastForward = false
    
    @Published private(set) var currentTime: MediaTime = .zero
    @Published private(set) var duration: MediaTime = .zero
    @Published private(set) var formattedCurrentTime = "00:00"
    @Published private(set) var formattedDuration = "00:00"

    var videoSize: (() -> CGRect)?

    private var playlist: Playlist?

    var currentlyPlayingVideo: Video? {
        playlistPlayer.currentlyPlayingVideo
    }

    var videoTitle: String {
        currentlyPlayingVideo?.filename ?? ""
    }

    var loopMode: LoopMode {
        get {
            playlistPlayer.loopMode
        }
        set {
            objectWillChange.send()
            playlistPlayer.loopMode = newValue
        }
    }

    // MARK: - Init

    init(playlistPlayer: PlaylistPlayer) {
        self.playlistPlayer = playlistPlayer
        self.loopMode = Current.userPreferencesManager.loopMode
        self.playlistPlayer.addObserver(self)
    }

    convenience init() {
        self.init(playlistPlayer: PlaylistPlayerImpl())
    }

    // MARK: - Public

    func play() {
        playlistPlayer.play()
    }

    func pause() {
        playlistPlayer.pause()
    }

    func nextItem() {
        playlistPlayer.nextItem()
    }

    func previousItem() {
        playlistPlayer.previousItem()
    }

    func skipToItem(at index: Int) {
        playlistPlayer.skipToItem(at: index)
    }

    func step(byFrames frames: Int) {
        playlistPlayer.step(byFrames: frames)
    }
    
    func seek(to time: MediaTime) {
        playlistPlayer.seek(to: time)
    }

    func updateQueue(for playlist: Playlist) {
        playlistPlayer.updateQueue(for: playlist)
    }

    // MARK: - Scrubbing

    func scrubbingDidStart() {
        playlistPlayer.scrubbingDidStart()
    }

    func scrubbingDidEnd() {
        playlistPlayer.scrubbingDidEnd()
    }

    func scrubbed(to time: MediaTime) {
        playlistPlayer.scrubbed(to: time)
    }

    // MARK: - Playback Rate

    func playFastForward() {
        playlistPlayer.playFastForward()
    }

    func playFastReverse() {
        playlistPlayer.playFastReverse()
    }
    
    // MARK: - PlayerView

    func setVideoPlayer(view: PlayerView) {
        playlistPlayer.setVideoPlayer(view: view)
    }
}

// MARK: - PlaylistPlayerObserver

extension PlaylistPlayerViewModel: PlaylistPlayerObserver {

    func loopModeDidUpdate(newValue: LoopMode) {
        objectWillChange.send()
    }

    func playbackReadinessDidChange(isReady: Bool) {
        isReadyForPlayback = isReady
    }

    func playbackFastReverseAbilityDidChange(canPlayFastReverse: Bool) {
        self.canPlayFastReverse = canPlayFastReverse
    }

    func playbackFastForwardAbilityDidChange(canPlayFastForward: Bool) {
        self.canPlayFastForward = canPlayFastForward
    }

    func playbackDurationDidChange(to time: MediaTime) {
        self.duration = time
        self.formattedDuration = TimeFormatter.string(from: Int(time.seconds))
    }

    func playbackStateDidChange(to playPauseState: PlayPauseState) {
        switch playPauseState {
        case .paused: isPlaying = false
        case .playing: isPlaying = true
        }
    }

    func playbackPositionDidChange(to time: MediaTime) {
        currentTime = time
        formattedCurrentTime = TimeFormatter.string(from: Int(time.seconds))
    }
}
