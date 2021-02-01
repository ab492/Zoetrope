//
//  PlaylistPlayer.swift
//  QueueTet
//
//  Created by Andy Brown on 05/01/2021.
//

import Foundation
import AVFoundation

enum LoopMode {
    case loopCurrent
    case loopPlaylist
    case playPlaylistOnce
}

protocol PlaylistPlayerProtocol {

    func play()
    func pause()
    func playNext()
    func playPrevious()
    func skipToItem(at index: Int)
    func step(byFrames count: Int)
    func seek(to time: Time)
    func replaceQueue(with items: [AVPlayerItem])

    var loopMode: LoopMode { get set }
    var currentItemDuration: Time { get set }
    var volume: Float { get set }


    var observer: PlaylistPlayerObserver { get set }
}

protocol PlaylistPlayerObserver: class {
    func playbackItemStatusDidChange(to status: ItemStatus)
    func playbackStateDidChange(to playbackState: PlaybackState)
    func playbackPositionDidChange(to time: Time)
    func mediaFastForwardAbilityDidChange(to newStatus: Bool)
    func mediaFastReverseAbilityDidChange(to newStatus: Bool)
    func mediaReverseAbilityDidChange(to newStatus: Bool)
    func currentItemDidFinishPlayback()
}

/// Creates a video player for queuing content and navigating forward and back.
final class PlaylistPlayer {

    // MARK: - Public Properties

    var player: VideoQueuePlayerProtocol
    weak var observer: PlaylistPlayerObserver?

    /// The loop mode for the playlist. This can be changed at any time throughout playback and the player will adjust to the new value. **Default: `.playPlaylistOnce`.**
    var loopMode: LoopMode = .playPlaylistOnce {
        didSet { setNeedsRequeueAndPrepare() }
    }

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

    private var needsRequeue = false

    // MARK: - Init

    init(items: [AVPlayerItem], videoPlayer: VideoQueuePlayerProtocol) {
        playerItems = items
        player = videoPlayer
        player.observer = self

        player.queueItems(items)
    }

    convenience init(items: [AVPlayerItem]) {
        self.init(items: items, videoPlayer: WrappedAVQueuePlayer())
    }

    // MARK: - Public Methods

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func playNext() {

        defer {
            requeueIfNeeded()
        }

        switch loopMode {

        case .loopCurrent:
            nowPlayingIndex += 1
            // We're moving to the next item to loop, so we need to rebuild the queue with that item.
            setNeedsRequeueAndPrepare()

        case .playPlaylistOnce:
            if atEndOfQueue == false {
                nowPlayingIndex += 1
            }
            // We want to advance to the next item anyway, since it'll terminate the queue if we're at the end.
            player.advanceToNextItem()

        case .loopPlaylist:
            if atEndOfQueue {
                nowPlayingIndex = 0
                setNeedsRequeueAndPrepare()
            } else {
                nowPlayingIndex += 1
                player.advanceToNextItem()
            }
        }
    }

    func playPrevious() {

        // Because `WrappedAVQueuePlayer` doesn't support skipping to the previous item (because items are removed once they're played) we have to rebuild the queue every time the user plays previous.

        defer {
            requeueIfNeeded()
        }

        if atBeginningOfQueue {
            player.seek(to: .zero)
        } else {
            nowPlayingIndex -= 1
            setNeedsRequeueAndPrepare()
        }
    }

    func skipToItem(at index: Int) {
        var index = index

        if index < 0 {
            index = 0
        } else if index > playerItems.count {
            index = playerItems.count - 1
        }

        nowPlayingIndex = index
        setNeedsRequeueAndPrepare()
        requeueIfNeeded()
    }

    func step(byFrames count: Int) {
        player.step(byFrames: count)
    }

    func seek(to time: Time) {
        player.seek(to: MediaTime(seconds: time.seconds))
    }

    func replaceQueue(with items: [AVPlayerItem]) {
        playerItems = items
        player.queueItems(playerItems)
        setNeedsRequeueAndPrepare()
        requeueIfNeeded()
    }

    // MARK: - Private Methods

    private func requeueIfNeeded() {
        guard needsRequeue == true else { return }

        defer {
            needsRequeue = false
        }

        if player.items().count > 0 { player.removeAllItems() }

        switch loopMode {

        case .loopCurrent:
            addTemplateItemsToLoopQueue(count: 3)
        case .playPlaylistOnce, .loopPlaylist:
            for index in nowPlayingIndex..<playerItems.count {
                let item = playerItems[index]
                item.seek(to: .zero, completionHandler: nil)
                player.insert(item: item, after: nil)
            }
        }
    }

    /// Invalidates the current queue and removes all outstanding items. The currently playing item is unaffected.
    private func setNeedsRequeueAndPrepare() {
        needsRequeue = true

        // This is required to prevent any flickering of the next item whilst we're rebuilding the queue.
        removeAllItemsExceptCurrentFromQueue()
    }

    private func removeAllItemsExceptCurrentFromQueue() {
        while player.items().count > 1 {
            player.remove(item: player.items()[1])
        }
    }

    private func addTemplateItemsToLoopQueue(count: Int) {
        let newItems = templateLoopItems(count: 3)
        for item in newItems {
            player.insert(item: item, after: player.items().last)
        }
    }

    private func templateLoopItems(count: Int) -> [AVPlayerItem] {
        var items = [AVPlayerItem]()

        for _ in 1...count {
            // We can't add the same instance of an item to the player more than once, so we'll make a copy.
            let copy = playerItems[nowPlayingIndex].copy() as! AVPlayerItem
            copy.seek(to: .zero, completionHandler: nil)
            items.append(copy)
        }

        return items
    }
}

extension PlaylistPlayer: VideoPlayerObserver {

    func currentItemDidFinishPlayback() {
        observer?.currentItemDidFinishPlayback()

        defer {
            requeueIfNeeded()
        }

        switch loopMode {

        case .loopCurrent:
            if player.items().count == 2 {
                // Add more template items to the looper to prevent any stuttering.
                addTemplateItemsToLoopQueue(count: 3)
            }

        case .playPlaylistOnce:
            if atEndOfQueue {
                return
            } else {
                nowPlayingIndex += 1
            }

        case .loopPlaylist:
            if atEndOfQueue {
                nowPlayingIndex = 0
                setNeedsRequeueAndPrepare()
            } else {
                nowPlayingIndex += 1
            }
        }
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

extension PlaylistPlayerObserver {
    func playbackItemStatusDidChange(to status: ItemStatus) { }
    func playbackStateDidChange(to playbackState: PlaybackState) { }
    func playbackPositionDidChange(to time: Time) { }
    func mediaFastForwardAbilityDidChange(to newStatus: Bool) { }
    func mediaFastReverseAbilityDidChange(to newStatus: Bool) { }
    func mediaReverseAbilityDidChange(to newStatus: Bool) { }
    func currentItemDidFinishPlayback() { }
}

