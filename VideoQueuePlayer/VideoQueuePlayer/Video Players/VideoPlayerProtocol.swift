//
//  VideoPlayerProtocol.swift
//  VideoQueuePlayer
//
//  Created by Andy Brown on 05/08/2022.
//

import Foundation
import AVFoundation

public enum PlaybackState: Int {
    case playing
    case paused
    case waitingToPlayAtSpecifiedRate
}

public enum ItemStatus {
    case readyToPlay
    case failed(Error)
    case unknown
}

public protocol VideoPlayerProtocol {
    var observer: VideoPlayerObserver? { get set }

    // Player Information
    var playbackRate: Float { get set }
    var duration: MediaTime { get }
    var currentTime: MediaTime { get }
    var status: ItemStatus { get }
    var volume: Float { get set }
    var playbackState: PlaybackState { get }
    var mediaIsReadyToPlayFastForward: Bool { get }
    var mediaIsReadyToPlayFastReverse: Bool { get }

    // Player Actions
    func play()
    func pause()
    func cancelPendingSeeks()
    func seek(to time: MediaTime)
    func replaceCurrentItem(with item: PlayerItem)
    func step(byFrames count: Int)

    // PlayerView
    func setVideoPlayer(view: PlayerView)
}

public protocol VideoPlayerObserver: AnyObject {
    func playbackItemStatusDidChange(to status: ItemStatus)
    func playbackStateDidChange(to playbackState: PlaybackState)
    func playbackPositionDidChange(to time: MediaTime)
    func mediaFastForwardAbilityDidChange(to newStatus: Bool)
    func mediaFastReverseAbilityDidChange(to newStatus: Bool)
    func mediaReverseAbilityDidChange(to newStatus: Bool)
    func currentItemDidFinishPlayback()
}
