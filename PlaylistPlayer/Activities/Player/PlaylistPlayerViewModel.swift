//
//  PlayerViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import AVFoundation
import SwiftUI

protocol PlaylistPlayerViewModelProtocol {

    var player: PlaylistPlayerProtocol { get } // Not sure about this one

    var isPlaying: Bool { get }
    var isReadyForPlayback: Bool { get }
    var canPlayFastReverse: Bool { get }
    var canPlayFastForward: Bool { get }

    var currentTime: MediaTime { get }
    var duration: MediaTime { get }
    var formattedCurrentTime: String { get }
    var formattedDuration: String { get }

    var currentlyPlayingVideo: Video? { get }
    var videoTitle: String { get }
    var loopMode: LoopMode { get }

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
}


class PlaylistPlayerViewModel: PlaylistPlayerViewModelProtocol, ObservableObject {

    // MARK: - Properties

    var player: PlaylistPlayerProtocol

    @Published private(set) var isPlaying = false
    @Published private(set) var isReadyForPlayback = false
    @Published private(set) var canPlayFastReverse = false
    @Published private(set) var canPlayFastForward = false
    
    @Published private(set) var currentTime: MediaTime = .zero
    @Published private(set) var duration: MediaTime = .zero
    @Published private(set) var formattedCurrentTime = "00:00"
    @Published private(set) var formattedDuration = "00:00"

    private var playlist: Playlist?

    // TODO: Test this
    var currentlyPlayingVideo: Video? {
        playlist?.videos[player.nowPlayingIndex]
    }

    var videoTitle: String {
        currentlyPlayingVideo?.filename ?? ""
    }

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
            objectWillChange.send()
            player.loopMode = newValue
            Current.userPreferencesManager.loopMode = newValue
        }
    }

    // MARK: - Init

    init(playlistPlayer: PlaylistPlayerProtocol) {
        self.player = playlistPlayer
        self.loopMode = Current.userPreferencesManager.loopMode
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

// MARK: - PlaylistPlayerObserver

extension PlaylistPlayerViewModel: PlaylistPlayerObserver {

    func playbackItemStatusDidChange(to status: ItemStatus) {
        switch status {
        case .readyToPlay:
            duration = player.currentItemDuration
            formattedDuration = TimeFormatter.string(from: Int(player.currentItemDuration.seconds))
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
