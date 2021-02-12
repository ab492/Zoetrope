//
//  PlayerViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import AVFoundation
import SwiftUI

class PlaylistPlayerViewModel: ObservableObject {

//    let items = ["01", "02", "03", "04", "05", "06", "07", "08"].compactMap { Bundle.main.url(forResource: $0, withExtension: "mov") }
//        .map { AVPlayerItem(url: $0)}
    var player: PlaylistPlayerProtocol

    // MARK: - Published
    
    @Published private(set) var isPlaying = false
    @Published private(set) var isReadyForPlayback = false
    @Published private(set) var canPlayFastReverse = false
    @Published private(set) var canPlayFastForward = false
    @Published private(set) var loopMode: LoopMode

    @Published private(set) var currentTime: Time = .zero
    @Published private(set) var duration: Time = .zero
    @Published private(set) var formattedCurrentTime = "00:00"
    @Published private(set) var formattedDuration = "00:00"
    
    init() {
        self.player = PlaylistPlayer()
        self.loopMode = player.loopMode
        self.player.observer = self
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func nextItem() {
        player.playNext()
    }

    func previousItem() {
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
    
    func setLoopMode(to loopMode: LoopMode) {
        // Here we need to keep model and view in sync - need to find a nicer way to do this.
        player.loopMode = loopMode
        self.loopMode = player.loopMode
    }

    func updateQueue(for playlist: Playlist) {
        print("UPDATE QUEUE CALLED!")
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
            isReadyForPlayback = true
            duration = player.currentItemDuration
            formattedDuration = TimeFormatter.string(from: Int(player.currentItemDuration.seconds))
        case .failed, .unknown:
            isReadyForPlayback = false
        }
    }

    func playbackStateDidChange(to playbackState: PlaybackState) {
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
        canPlayFastForward = newStatus
    }

    func mediaFastReverseAbilityDidChange(to newStatus: Bool) {
        canPlayFastReverse = newStatus
    }
}
