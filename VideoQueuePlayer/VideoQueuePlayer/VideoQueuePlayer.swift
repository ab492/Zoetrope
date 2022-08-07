//
//  PlaylistPlayer.swift
//  QueueTet
//
//  Created by Andy Brown on 05/01/2021.
//

import Foundation
import ABExtensions
import AVFoundation

public protocol VideoQueuePlayerProtocol {

    // Player Actions
    func play()
    func pause()
    func playNext()
    func playPrevious()
    func skipToItem(at index: Int)
    func step(byFrames count: Int)
    func seek(to time: MediaTime)
    func replaceQueue(with items: [AVPlayerItem])
    func scrubbingDidStart()
    func scrubbed(to time: MediaTime)
    func scrubbingDidEnd()
    func playFastForward()
    func playFastBackward()

    // Player Information
    var nowPlayingIndex: Int { get }
    var loopMode: LoopMode { get set }
    var playbackRate: Float { get set }
    var currentItemDuration: MediaTime { get }
    var volume: Float { get set }
    var observer: VideoQueuePlayerObserver? { get set }

    // PlayerView
    func setVideoPlayer(view: PlayerView)
}

public protocol VideoQueuePlayerObserver: AnyObject {
    func playbackItemStatusDidChange(to status: ItemStatus)
    func playbackStateDidChange(to playbackState: PlaybackState)
    func playbackPositionDidChange(to time: MediaTime)
    func mediaFastForwardAbilityDidChange(to newStatus: Bool)
    func mediaFastReverseAbilityDidChange(to newStatus: Bool)
    func mediaReverseAbilityDidChange(to newStatus: Bool)
    func currentItemDidFinishPlayback()
}

/// Creates a video player for queuing content and navigating forward and back.
public final class VideoQueuePlayer: VideoQueuePlayerProtocol {

    // MARK: Properties

    private var player: VideoPlayerProtocol
    public weak var observer: VideoQueuePlayerObserver?

    /// The loop mode for the playlist. This can be changed at any time throughout playback and the player will adjust to the new value. **Default: `.playPlaylistOnce`.**
    public var loopMode: LoopMode = .playPlaylistOnce

    /// The rate of playback.
    public var playbackRate: Float {
        get { player.playbackRate }
        set { player.playbackRate = newValue }
    }

    /// The index of the currently playing item. If there are no items, this index will be 0. **This is a zero based index (i.e. the first item has an index of 0).**
    public private(set) var nowPlayingIndex = 0

    /// 0.0 indicates silence; 1.0 indicates full volume. The player volume is relative to the system volume, so a value of 1.0 will match the current system volume exactly. **Default: 1.0.**
    public var volume: Float {
        get { player.volume }
        set { player.volume = newValue }
    }

    public var currentItemDuration: MediaTime {
        player.duration
    }

    // MARK: - Private Properties

    private var playerItems: [AVPlayerItem] // The master queue

    private var atBeginningOfQueue: Bool {
        nowPlayingIndex == 0
    }

    private var atEndOfQueue: Bool {
        nowPlayingIndex == playerItems.count - 1
    }

    private var lastPlaybackRate: Float = 0
    private var isScrubbing = false

    // MARK: - Init

    public init(items: [AVPlayerItem], videoPlayer: VideoPlayerProtocol) {
        playerItems = items
        player = videoPlayer
        player.observer = self
    }

    public convenience init() {
        self.init(items: [])
    }

    public convenience init(items: [AVPlayerItem]) {
        self.init(items: items, videoPlayer: WrappedAVPlayer())
    }
}

// MARK: - Basic Playlist Playback

extension VideoQueuePlayer {

    public func play() {
        guard let currentItem = playerItems[maybe: nowPlayingIndex] else { return }
        // Since calling `replaceCurrentItem` with the player’s current player item has no effect, it's safe to always call it.
        player.replaceCurrentItem(with: currentItem)
        player.play()
    }

    public func pause() {
        player.pause()
    }

    public func playNext() {

        switch loopMode {

        case .loopCurrent, .loopPlaylist:
            if atEndOfQueue {
                // Restart the queue
                nowPlayingIndex = 0
            } else {
                nowPlayingIndex += 1
            }

        case .playPlaylistOnce:
            if atEndOfQueue == false {
                nowPlayingIndex += 1
            }
        }
        updateCurrentPlayerItem()
    }

    public func playPrevious() {

        switch loopMode {
        case .loopCurrent, .loopPlaylist:
            if atBeginningOfQueue {
                // If we're at the beginning, loop around to the last item in the array.
                nowPlayingIndex = playerItems.count - 1
            } else {
                nowPlayingIndex -= 1
            }
            
        case .playPlaylistOnce:
            if atBeginningOfQueue {
                player.seek(to: .zero)
            } else {
                nowPlayingIndex -= 1
            }
        }
        updateCurrentPlayerItem()
    }

    /// Skips to item at the given index. **This is a zero based index (i.e. the first item has an index of 0).**
    public func skipToItem(at index: Int) {
        guard playerItems.count > 0 else { return }
        let index = index.clamped(to: 0...playerItems.count - 1)
        nowPlayingIndex = index
        updateCurrentPlayerItem()
    }

    public func step(byFrames count: Int) {
        player.step(byFrames: count)
    }

    public func seek(to time: MediaTime) {
        player.seek(to: time)
    }

    public func replaceQueue(with items: [AVPlayerItem]) {
        // TODO: Need to use this to test behavior!
        // DO WE NEED TO STOP THE PLAYER?!
        player.pause()
        playerItems = items
        nowPlayingIndex = 0
    }

    private func updateCurrentPlayerItem() {
        guard let item = playerItems[maybe: nowPlayingIndex] else { return }
        lastPlaybackRate = player.playbackRate
        // Important to pause the player before updating the current item to prevent any weird play-pause behavior (e.g randomly becoming paused).
        player.playbackRate = 0
        item.seek(to: .zero, completionHandler: nil)
        player.replaceCurrentItem(with: item)
        if lastPlaybackRate > 0 {
            player.playbackRate = lastPlaybackRate
        }
    }
}

// MARK: - Scrubbing and Seeking Through Media

extension VideoQueuePlayer {

    public func scrubbingDidStart() {
        lastPlaybackRate = player.playbackRate
        pause()
    }

    public func scrubbed(to time: MediaTime) {
        player.cancelPendingSeeks()
        player.seek(to: time)
    }

    public func scrubbingDidEnd() {
        if lastPlaybackRate > 0 { play() }
    }
}

// MARK: - Playback Rate

extension VideoQueuePlayer {
    public func playFastForward() {
        player.playbackRate = 2.0
    }

    public func playFastBackward() {
        player.playbackRate = -2.0
    }
}

// MARK: - PlayerView Setup

extension VideoQueuePlayer {
    public func setVideoPlayer(view: PlayerView) {
        player.setVideoPlayer(view: view)
    }
}

// MARK: - VideoPlayerObserver

extension VideoQueuePlayer: VideoPlayerObserver {

    public func currentItemDidFinishPlayback() {
        observer?.currentItemDidFinishPlayback()

        switch loopMode {

        case .loopCurrent:
            break

        case .playPlaylistOnce:
            if atEndOfQueue {
                return
            } else {
                nowPlayingIndex += 1
            }

        case .loopPlaylist:
            if atEndOfQueue {
                nowPlayingIndex = 0
            } else {
                nowPlayingIndex += 1
            }
        }

        updateCurrentPlayerItem()
        player.play()
    }

    public func playbackItemStatusDidChange(to status: ItemStatus) {
        observer?.playbackItemStatusDidChange(to: status)
    }

    public func playbackStateDidChange(to playbackState: PlaybackState) {
        observer?.playbackStateDidChange(to: playbackState)
    }

    public func playbackPositionDidChange(to time: MediaTime) {
        // We don't want position events firing while the user is scrubbing. TEST THIS
        guard isScrubbing == false else { return }
        observer?.playbackPositionDidChange(to: time)
    }

    public func mediaFastForwardAbilityDidChange(to newStatus: Bool) {
        observer?.mediaFastForwardAbilityDidChange(to: newStatus)
    }

    public func mediaFastReverseAbilityDidChange(to newStatus: Bool) {
        observer?.mediaFastReverseAbilityDidChange(to: newStatus)
    }

    public func mediaReverseAbilityDidChange(to newStatus: Bool) {
        observer?.mediaReverseAbilityDidChange(to: newStatus)
    }
}

extension VideoQueuePlayerObserver {
    public func playbackItemStatusDidChange(to status: ItemStatus) { }
    public func playbackStateDidChange(to playbackState: PlaybackState) { }
    public func playbackPositionDidChange(to time: MediaTime) { }
    public func mediaFastForwardAbilityDidChange(to newStatus: Bool) { }
    public func mediaFastReverseAbilityDidChange(to newStatus: Bool) { }
    public func mediaReverseAbilityDidChange(to newStatus: Bool) { }
    public func currentItemDidFinishPlayback() { }
}
