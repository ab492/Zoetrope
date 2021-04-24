//
//  PlaylistPlayerImpl.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 27/03/2021.
//

import AVFoundation
import Foundation

final class PlaylistPlayerImpl: PlaylistPlayer {

    // MARK: - Properties

    private var player: VideoQueuePlayerProtocol

    private(set) var isPlaying = false {
        didSet {
            notifyPlaybackStateDidChange(to: isPlaying ? .playing : .paused)
        }
    }

    private(set) var isReadyForPlayback = false {
        didSet {
            notifyPlaybackReadinessDidChange(isReady: isReadyForPlayback)
        }
    }

    private(set) var canPlayFastReverse = false {
        didSet {
            notifyPlaybackFastReverseAbilityDidChange(canPlayFastReverse: canPlayFastReverse)
        }
    }

    private(set) var canPlayFastForward = false {
        didSet {
            notifyPlaybackFastForwardAbilityDidChange(canPlayFastForward: canPlayFastForward)
        }
    }

    private(set) var currentTime: MediaTime = .zero {
        didSet {
            notifyPlaybackPositionDidChange(to: currentTime)
        }
    }

    private(set) var duration: MediaTime = .zero {
        didSet {
            notifyPlaybackDurationDidChange(to: duration)
        }
    }

    private var playlist: Playlist?

    var currentlyPlayingVideo: Video? {
        playlist?.videos[player.nowPlayingIndex]
    }

    var observations = [ObjectIdentifier : WeakBox<PlaylistPlayerObserver>]()

    // When the user skips between videos, the change of playback state (i.e. from
    // playing to loading) causes the play button to flicker between play-pause-play.
    // To prevent this, we take a time stamp on skip to provide a very small window
    // where we don't respond to playback state updates.
    private var playlistSkipTimestamp: Double?

    private var isWithinPlaylistSkipCompletionTime: Bool {
        if let previousTimestamp = playlistSkipTimestamp {
            return (Current.dateTimeService.absoluteTime - previousTimestamp >= 0.3) ? false : true
        } else {
            return false
        }
    }

    var loopMode: LoopMode {
        get {
            player.loopMode
        }
        set {
            player.loopMode = newValue
            Current.userPreferencesManager.loopMode = newValue
            notifyLoopModeDidUpdate(newValue: newValue)
        }
    }

    // MARK: - Init

    init(videoQueuePlayer: VideoQueuePlayerProtocol) {
        self.player = videoQueuePlayer
        DispatchQueue.main.async {
            // TODO: Could do this is a setup function (maybe using mirroring?!)
            self.loopMode = Current.userPreferencesManager.loopMode
        }
        self.player.observer = self
    }

    convenience init() {
        self.init(videoQueuePlayer: VideoQueuePlayer())
    }

    // MARK: - Public

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func nextItem() {
        playlistSkipTimestamp = Current.dateTimeService.absoluteTime
        player.playNext()
    }

    func previousItem() {
        playlistSkipTimestamp = Current.dateTimeService.absoluteTime
        player.playPrevious()
    }

    func skipToItem(at index: Int) {
        player.skipToItem(at: index)
    }

    func step(byFrames frames: Int) {
        player.step(byFrames: frames)
    }
    
    func seek(to time: MediaTime) {
        player.seek(to: time)
    }

    func updateQueue(for playlist: Playlist) {
        self.playlist = playlist
        let urls = Current.playlistManager.mediaUrlsFor(playlist: playlist)
        let items = urls.map { AVURLAsset(url: $0, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true]) }
        let playerItems = items.map { AVPlayerItem(asset: $0) }
        player.replaceQueue(with: playerItems)
    }

    // MARK: - Scrubbing

    func scrubbingDidStart() {
        player.scrubbingDidStart()
    }

    func scrubbingDidEnd() {
        player.scrubbingDidEnd()
    }

    func scrubbed(to time: MediaTime) {
        player.scrubbed(to: time)
    }

    // MARK: - Playback Rate

    func playFastForward() {
        player.playFastForward()
    }

    func playFastReverse() {
        player.playFastBackward()
    }
}

// MARK: - VideoQueuePlayerObserver

extension PlaylistPlayerImpl: VideoQueuePlayerObserver {
    func playbackItemStatusDidChange(to status: ItemStatus) {
        switch status {
        case .readyToPlay:
            duration = player.currentItemDuration
            isReadyForPlayback = true

        case .failed, .unknown:
            isReadyForPlayback = false
        }
    }

    func playbackStateDidChange(to playbackState: PlaybackState) {
        // Don't update playback state if we're in the small window after the user has skipped in the playlist.
        guard isWithinPlaylistSkipCompletionTime == false else { return }

        switch playbackState {
        case .playing:
            isPlaying = true
        case .paused, .waitingToPlayAtSpecifiedRate:
            isPlaying = false
        }
    }

    func playbackPositionDidChange(to time: MediaTime) {
        currentTime = time
    }

    func mediaFastForwardAbilityDidChange(to newStatus: Bool) {
        guard isWithinPlaylistSkipCompletionTime == false else { return }

        canPlayFastForward = newStatus
    }

    func mediaFastReverseAbilityDidChange(to newStatus: Bool) {
        guard isWithinPlaylistSkipCompletionTime == false else { return }

        canPlayFastReverse = newStatus
    }
}

// MARK: - PlayerView

extension PlaylistPlayerImpl {
    func setVideoPlayer(view: PlayerView) {
        player.setVideoPlayer(view: view)
    }
}

