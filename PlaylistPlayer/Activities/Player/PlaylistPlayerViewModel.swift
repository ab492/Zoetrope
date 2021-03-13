//
//  PlayerViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import AVFoundation
import SwiftUI

class PlaylistPlayerViewModel: ObservableObject {

    // MARK: - Properties

    var player: PlaylistPlayerProtocol

    @Published private(set) var isPlaying = false
    @Published private(set) var isReadyForPlayback = false
    @Published private(set) var canPlayFastReverse = false
    @Published private(set) var canPlayFastForward = false
    
    @Published private(set) var currentTime: Time = .zero
    @Published private(set) var duration: Time = .zero
    @Published private(set) var formattedCurrentTime = "00:00"
    @Published private(set) var formattedDuration = "00:00"

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
//            player.loopMode
            Current.userPreferencesManager.loopMode
        }
        set {
            objectWillChange.send()
            player.loopMode = newValue
            Current.userPreferencesManager.loopMode = newValue
        }
    }

    // MARK: - Init

    init(playlistPlayer: PlaylistPlayerProtocol) {
        self.player = playlistPlayer
        self.player.observer = self
    }

    convenience init() {
        self.init(playlistPlayer: PlaylistPlayer())
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

    // MARK: - WIP - NEED TO TEST

    func seek(to time: Time) {
        player.seek(to: time)
    }

    func updateQueue(for playlist: Playlist) {
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

    func scrubbed(to time: Time) {
        player.scrubbed(to: MediaTime(seconds: time.seconds))
    }

    // MARK: - Playback Rate

    func playFastForward() {
        player.playFastForward()
    }

    func playFastReverse() {
        player.playFastBackward()
    }
}

// MARK: - PlaylistPlayerObserver

extension PlaylistPlayerViewModel: PlaylistPlayerObserver {

    func playbackItemStatusDidChange(to status: ItemStatus) {
        switch status {
        case .readyToPlay:
            duration = player.currentItemDuration
            formattedDuration = TimeFormatter.string(from: Int(player.currentItemDuration.seconds))
            isReadyForPlayback = true

            // Don't update playback state if we're in the small window after the user has skipped in the playlist.
//            if isWithinPlaylistSkipCompletionTime == false {
//                isReadyForPlayback = true
//            }

        case .failed:
            isReadyForPlayback = false

        case .unknown:
            isReadyForPlayback = false

//            // Don't update playback state if we're in the small window after the user has skipped in the playlist.
//            if isWithinPlaylistSkipCompletionTime == false {
//                isReadyForPlayback = false
//            }
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

    func playbackPositionDidChange(to time: Time) {
        formattedCurrentTime = TimeFormatter.string(from: Int(time.seconds))
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
