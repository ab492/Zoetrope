//
//  PlayerViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import AVFoundation
import SwiftUI

class PlaylistPlayerViewModel: ObservableObject {

    let items = ["01", "02", "03", "04", "05", "06", "07", "08"].compactMap { Bundle.main.url(forResource: $0, withExtension: "mov") }
    let player: PlaylistPlayer

    // MARK: - Published
    
    @Published var isPlaying = false
    @Published var isReadyForPlayback = false
    @Published var canPlayFastReverse = false
    @Published var canPlayFastForward = false
    @Published var loopMode: PlaylistPlayer.LoopMode

    init() {
        self.player = PlaylistPlayer(items: items.map { AVPlayerItem(url: $0) })
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
    
    func setLoopMode(to loopMode: PlaylistPlayer.LoopMode) {
        // Here we need to keep model and view in sync - need to find a nicer way to do this.
        player.loopMode = loopMode
        self.loopMode = player.loopMode
    }
}

extension PlaylistPlayerViewModel: PlaylistPlayerObserver {

    func playbackItemStatusDidChange(to status: ItemStatus) {
        switch status {
        case .readyToPlay:
            isReadyForPlayback = true
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

    func mediaFastForwardAbilityDidChange(to newStatus: Bool) {
        canPlayFastForward = newStatus
    }

    func mediaFastReverseAbilityDidChange(to newStatus: Bool) {
        canPlayFastReverse = newStatus
    }
}
