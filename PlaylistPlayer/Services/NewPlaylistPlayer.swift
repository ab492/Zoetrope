//
//  PlaylistPlayer.swift
//  QueueTet
//
//  Created by Andy Brown on 05/01/2021.
//

import Foundation
import AVFoundation

/// Creates a video player for queuing content and navigating forward and back.
final class NewPlaylistPlayer: PlaylistPlayerProtocol {

    // MARK: - Public Properties

    var player: VideoPlayerProtocol
    weak var observer: PlaylistPlayerObserver?

    /// The loop mode for the playlist. This can be changed at any time throughout playback and the player will adjust to the new value. **Default: `.playPlaylistOnce`.**
    var loopMode: LoopMode = .playPlaylistOnce

    /// The index of the currently playing item. **This is a zero based index (i.e. the first item has an index of 0).**
    private(set) var nowPlayingIndex = 0

    /// 0.0 indicates silence; 1.0 indicates full volume. The player volume is relative to the system volume, so a value of 1.0 will match the current system volume exactly. **Default: 1.0.**
    var volume: Float {
        get { player.volume }
        set { player.volume = newValue }
    }

    var currentItemDuration: Time {
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
    
    // MARK: - Init

    init(items: [AVPlayerItem], videoPlayer: VideoPlayerProtocol) {
        playerItems = items
        player = videoPlayer
        player.observer = self
    }

    convenience init() {
        self.init(items: [])
    }

    convenience init(items: [AVPlayerItem]) {
        self.init(items: items, videoPlayer: WrappedAVPlayer())
    }

    // MARK: - Public

    func play() {
        // Since calling `replaceCurrentItem` with the player’s current player item has no effect, it's safe to always call it.
        player.replaceCurrentItem(with: playerItems[nowPlayingIndex])
        player.play()
    }

    func pause() {
        player.pause()
    }

    func playNext() {

        switch loopMode {

        case .loopCurrent:
            // We're moving to the next item to loop.
            nowPlayingIndex += 1

        case .playPlaylistOnce:
            if atEndOfQueue == false {
                nowPlayingIndex += 1
            }

        case .loopPlaylist:
            if atEndOfQueue {
                // Restart the queue
                nowPlayingIndex = 0
            } else {
                nowPlayingIndex += 1
            }
        }
        updateCurrentPlayerItem()
    }

    func playPrevious() {

        if atBeginningOfQueue {
            player.seek(to: .zero)
        } else {
            nowPlayingIndex -= 1
        }

        updateCurrentPlayerItem()
    }

    func skipToItem(at index: Int) {
        let index = index.clamped(to: 0...playerItems.count - 1)
        nowPlayingIndex = index
        updateCurrentPlayerItem()
    }

    func step(byFrames count: Int) {
        player.step(byFrames: count)
    }

    func seek(to time: Time) {
        player.seek(to: MediaTime(seconds: time.seconds))
    }


    func replaceQueue(with items: [AVPlayerItem]) {
        // TODO: Need to use this to test behaviour!
        // DO WE NEED TO STOP THE PLAYER?!
        playerItems = items
        nowPlayingIndex = 0
    }

    // MARK: - Private

    private func updateCurrentPlayerItem() {
        let item = playerItems[nowPlayingIndex]
        item.seek(to: .zero, completionHandler: nil)
        player.replaceCurrentItem(with: item)
    }
}

extension NewPlaylistPlayer: VideoPlayerObserver {

    func currentItemDidFinishPlayback() {
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

        let item = playerItems[nowPlayingIndex]
        item.seek(to: .zero, completionHandler: nil)
        player.replaceCurrentItem(with: item)
        player.play()
    }

    func playbackItemStatusDidChange(to status: ItemStatus) {
        observer?.playbackItemStatusDidChange(to: status)
    }

    func playbackStateDidChange(to playbackState: PlaybackState) {
        observer?.playbackStateDidChange(to: playbackState)
    }

    func playbackPositionDidChange(to time: MediaTime) {
        observer?.playbackPositionDidChange(to: Time(seconds: time.seconds))
    }

    func mediaFastForwardAbilityDidChange(to newStatus: Bool) {
        observer?.mediaFastForwardAbilityDidChange(to: newStatus)
    }

    func mediaFastReverseAbilityDidChange(to newStatus: Bool) {
        observer?.mediaFastReverseAbilityDidChange(to: newStatus)
    }

    func mediaReverseAbilityDidChange(to newStatus: Bool) {
        observer?.mediaReverseAbilityDidChange(to: newStatus)
    }

}
