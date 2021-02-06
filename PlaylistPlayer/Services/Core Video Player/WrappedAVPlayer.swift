
//  VideoPlayer.swift
//  QFS
//
//  Created by Andy Brown on 24/05/2020.
//  Copyright © 2020 Andy Brown. All rights reserved.
//

import Foundation
import AVFoundation

/// A protocol to mirror `AVPlayer`.
protocol VideoPlayerProtocol {
    var observer: VideoPlayerObserver? { get set }

    // Player Information
    var playbackRate: Float { get set }
    var duration: Time { get }
    var currentTime: Time { get }
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
    func replaceCurrentItem(with item: AVPlayerItem)
    func step(byFrames count: Int)
}

protocol VideoPlayerObserver: class {
    func playbackItemStatusDidChange(to status: ItemStatus)
    func playbackStateDidChange(to playbackState: PlaybackState)
    func playbackPositionDidChange(to time: MediaTime)
    func mediaFastForwardAbilityDidChange(to newStatus: Bool)
    func mediaFastReverseAbilityDidChange(to newStatus: Bool)
    func mediaReverseAbilityDidChange(to newStatus: Bool)
    func currentItemDidFinishPlayback()
}

enum PlaybackState: Int {
    case playing
    case paused
    case waitingToPlayAtSpecifiedRate
}

enum ItemStatus {
    case readyToPlay
    case failed(Error)
    case unknown
}

/// Provides a wrapper to make `AVPlayer` player easier to work with by using a delegates instead of KVO.
final class WrappedAVPlayer: VideoPlayerProtocol {

    weak var observer: VideoPlayerObserver?

    // MARK: - Private Properties
    // FIXME: Make this private again!
    var player: AVPlayer

    // MARK: - Observers
    private var timeObserverToken: Any?

    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    private var playerItemFastForwardObserver: NSKeyValueObservation?
    private var playerItemFastReverseObserver: NSKeyValueObservation?
    private var playerItemStatusObserver: NSKeyValueObservation?
    private var playerItemReverseObserver: NSKeyValueObservation?

    // MARK: - Init

    convenience init() {
        self.init(player: AVPlayer())
    }

    init(player: AVPlayer) {
        self.player = player
        setupObservers()
    }


    // MARK: - Observers

    private func setupObservers() {
        observeCurrentItemStatus()
        observeTimeControlStatus()
        observeCanFastForwardStatus()
        observeCanFastReverseStatus()
        observeCanReverseStatus()
        observeTimeInterval()

        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    private func removeObservers() {
        [playerTimeControlStatusObserver,
         playerItemFastForwardObserver,
         playerItemFastReverseObserver,
         playerItemStatusObserver,
         playerItemReverseObserver].forEach { $0?.invalidate() }

        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    private func observeCurrentItemStatus() {
        playerItemStatusObserver = player.observe(\.currentItem?.status) { [weak self] player, _ in
            DispatchQueue.main.async {
                switch player.currentItem?.status {
                case .readyToPlay:
                    self?.observer?.playbackItemStatusDidChange(to: .readyToPlay)
                case .failed:
                    if let error = player.currentItem?.error {
                        self?.observer?.playbackItemStatusDidChange(to: .failed(error))
                    } else {
                        self?.observer?.playbackItemStatusDidChange(to: .unknown)
                    }
                default:
                    self?.observer?.playbackItemStatusDidChange(to: .unknown)
                }
            }
        }
    }

    private func observeTimeControlStatus() {
        playerTimeControlStatusObserver = player.observe(\.timeControlStatus) { [weak self] player, _ in
            DispatchQueue.main.async {
                switch player.timeControlStatus {
                case .playing:  self?.observer?.playbackStateDidChange(to: .playing)
                case .paused: self?.observer?.playbackStateDidChange(to: .paused)
                default: break
                }
            }
        }
    }

    private func observeCanFastForwardStatus() {
        playerItemFastForwardObserver = player.observe(\.currentItem?.canPlayFastForward) { [weak self] player, _ in
            DispatchQueue.main.async {
                switch player.currentItem?.canPlayFastForward {
                case .some(true): self?.observer?.mediaFastForwardAbilityDidChange(to: true)
                case .some(false): self?.observer?.mediaFastForwardAbilityDidChange(to: false)
                case .none: break
                }
            }
        }
    }

    private func observeCanFastReverseStatus() {
        playerItemFastReverseObserver = player.observe(\.currentItem?.canPlayFastReverse) { [weak self] player, _ in
            DispatchQueue.main.async {
                switch player.currentItem?.canPlayFastReverse {
                case .some(true): self?.observer?.mediaFastReverseAbilityDidChange(to: true)
                case .some(false): self?.observer?.mediaFastReverseAbilityDidChange(to: false)
                case .none: break
                }
            }
        }
    }

    private func observeCanReverseStatus() {
        playerItemReverseObserver = player.observe(\.currentItem?.canPlayReverse) { [weak self] player, _ in
            DispatchQueue.main.async {
                switch player.currentItem?.canPlayReverse {
                case .some(true): self?.observer?.mediaReverseAbilityDidChange(to: true)
                case .some(false): self?.observer?.mediaReverseAbilityDidChange(to: false)
                case .none: break
                }
            }
        }
    }

    private func observeTimeInterval() {
        let interval = CMTime(seconds: 1.0 / 60, preferredTimescale: .default)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let timeElapsed = MediaTime(time: time)
            self?.observer?.playbackPositionDidChange(to: timeElapsed)
        }
    }

    @objc private func itemDidFinishPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.observer?.currentItemDidFinishPlayback()
        }
    }

    // MARK: - Private Helpers

    private func itemIsAtEnd() -> Bool {
        return player.currentItem?.currentTime() == player.currentItem?.duration
    }

    // MARK: - Deinit

    deinit {
        removeObservers()
    }
}

// MARK: - Public API

extension WrappedAVPlayer {

    /// Calling this method with the player’s current player item has no effect.
    func replaceCurrentItem(with item: AVPlayerItem) {
        player.replaceCurrentItem(with: item)
    }
    
    func play() {
        switch player.timeControlStatus {
        case .paused: player.play()
        case .playing: break
        default: player.play()
        }
    }

    func pause() {
        switch player.timeControlStatus {
        case .playing: player.pause()
        case .paused: break
        default: player.pause()
        }
    }

    var playbackRate: Float {
        get { return player.rate }
        set { player.rate = newValue }
    }

    /// The value of this property will be reported as indefinite (NAN) until the duration of the underlying asset has been loaded. 
    var duration: Time {
        let duration = player.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: .zero)
        let seconds = CMTimeGetSeconds(duration)
        return Time(seconds: seconds)
    }

    var actionAtItemEnd: AVPlayer.ActionAtItemEnd {
        get { player.actionAtItemEnd }
        set { player.actionAtItemEnd = newValue }
    }

    var currentTime: Time {
        let currentTime = player.currentItem?.currentTime() ?? CMTime(seconds: 0, preferredTimescale: .zero)
        let seconds = CMTimeGetSeconds(currentTime)
        return Time(seconds: seconds)
    }

    var playbackState: PlaybackState {
        switch player.timeControlStatus {
        case .paused:
            return .paused
        case .waitingToPlayAtSpecifiedRate:
            return .waitingToPlayAtSpecifiedRate
        case .playing:
            return .playing
        @unknown default:
            fatalError("Unknown playback state.")
        }
    }

    var status: ItemStatus {
        guard let item = player.currentItem else { return .unknown }

        switch item.status {
        case .unknown:
            return .unknown
        case .readyToPlay:
            return .readyToPlay
        case .failed:
            if let error = item.error {
                return .failed(error)
            } else {
                return .unknown
            }
        @unknown default:
            fatalError("Unknown item status.")
        }
    }

    /// 0.0 indicates silence; 1.0 indicates full volume. The player volume is relative to the system volume, so a value of 1.0 will match the current system volume exactly. **Default: 1.0.**
    var volume: Float {
        get { player.volume }
        set { player.volume = newValue }
    }

    var mediaIsReadyToPlayFastForward: Bool {
        return player.currentItem?.canPlayFastForward ?? false
    }

    var mediaIsReadyToPlayFastReverse: Bool {
        return player.currentItem?.canPlayFastReverse ?? false
    }

    /// The seek tolerance is at its most accurate.
    func seek(to time: MediaTime) {
        player.seek(to: CMTime(seconds: time.seconds, preferredTimescale: time.preferredTimescale),
                    toleranceBefore: .zero,
                    toleranceAfter: .zero)
    }

    func cancelPendingSeeks() {
        player.currentItem?.cancelPendingSeeks()
    }

    var mediaCanStepForward: Bool {
        player.currentItem?.canStepForward ?? false
    }

    var mediaCanStepBackward: Bool {
        player.currentItem?.canStepBackward ?? false
    }

    func step(byFrames count: Int) {
        player.currentItem?.step(byCount: count)
    }
}


// Exposes the underlying AVPlayer to UIView's PlayerLayer.
extension AVPlayerLayer {
    func setVideoPlayer(_ wrappedPlayer: WrappedAVPlayer) {
        player = wrappedPlayer.player
    }
}

// Exposes the underlying AVPlayer to our custom SwiftUI PlayerView.
extension PlayerView {
    func setVideoPlayer(_ wrappedPlayer: WrappedAVPlayer) {
        player = wrappedPlayer.player
    }
}


extension VideoPlayerObserver {
    func playbackItemStatusDidChange(to status: ItemStatus) { }
    func playbackStateDidChange(to playbackState: PlaybackState) { }
    func playbackPositionDidChange(to time: MediaTime) { }
    func mediaFastForwardAbilityDidChange(to newStatus: Bool) { }
    func mediaFastReverseAbilityDidChange(to newStatus: Bool) { }
    func mediaReverseAbilityDidChange(to newStatus: Bool) { }
    func currentItemDidFinishPlayback() { }
}
