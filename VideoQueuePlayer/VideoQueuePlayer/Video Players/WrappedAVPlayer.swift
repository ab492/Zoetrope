//  VideoPlayer.swift
//  QFS
//
//  Created by Andy Brown on 24/05/2020.
//  Copyright © 2020 Andy Brown. All rights reserved.
//

import AVFoundation

/// Provides a wrapper to make `AVPlayer` player easier to work with by using a delegates instead of KVO.
final public class WrappedAVPlayer: VideoPlayerProtocol {

    public weak var observer: VideoPlayerObserver?

    // MARK: - Private Properties

    private var player: AVPlayer

    // MARK: - Observers
    private var timeObserverToken: Any?

    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    private var playerItemFastForwardObserver: NSKeyValueObservation?
    private var playerItemFastReverseObserver: NSKeyValueObservation?
    private var playerItemStatusObserver: NSKeyValueObservation?
    private var playerItemReverseObserver: NSKeyValueObservation?
    
    // MARK: - Init

    public convenience init() {
        self.init(player: AVPlayer())
    }

    public init(player: AVPlayer) {
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
    public func replaceCurrentItem(with item: PlayerItem) {
        guard let wrappedItem = item as? WrappedAVPLayerItem else { return }
        player.replaceCurrentItem(with: wrappedItem)
    }

    public func play() {
        switch player.timeControlStatus {
        case .paused: player.play()
        case .playing: break
        default: player.play()
        }
    }

    public func pause() {
        switch player.timeControlStatus {
        case .playing: player.pause()
        case .paused: break
        default: player.pause()
        }
    }

    public var playbackRate: Float {
        get { return player.rate }
        set { player.rate = newValue }
    }

    public var duration: MediaTime {
        // The duration be reported as indefinite (NAN) until the duration of the asset has
        // been loaded, so we need to fallback to zero if indefinite.
        let duration = player.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: .zero)
        var mediaTime: MediaTime

        if duration.seconds.isNaN {
            mediaTime = .zero
        } else if duration.seconds.isInfinite {
            mediaTime = .zero
        } else {
            mediaTime = MediaTime(time: duration)
        }
        return mediaTime
    }

    public var actionAtItemEnd: AVPlayer.ActionAtItemEnd {
        get { player.actionAtItemEnd }
        set { player.actionAtItemEnd = newValue }
    }

    public var currentTime: MediaTime {
        // The duration be reported as indefinite (NAN) until the duration of the asset has
        // been loaded, so we need to fallback to zero if indefinite.
        let currentTime = player.currentItem?.currentTime() ?? CMTime(seconds: 0, preferredTimescale: .zero)
        var mediaTime: MediaTime

        if currentTime.seconds.isNaN {
            mediaTime = .zero
        } else if currentTime.seconds.isInfinite {
            mediaTime = .zero
        } else {
            mediaTime = MediaTime(time: currentTime)
        }
        return mediaTime
    }

    public var playbackState: PlaybackState {
        switch player.timeControlStatus {
        case .paused: return .paused
        case .waitingToPlayAtSpecifiedRate: return .waitingToPlayAtSpecifiedRate
        case .playing: return .playing
        @unknown default: fatalError("Unknown playback state.")
        }
    }

    public var status: ItemStatus {
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
    public var volume: Float {
        get { player.volume }
        set { player.volume = newValue }
    }

    public var mediaIsReadyToPlayFastForward: Bool {
        return player.currentItem?.canPlayFastForward ?? false
    }

    public var mediaIsReadyToPlayFastReverse: Bool {
        return player.currentItem?.canPlayFastReverse ?? false
    }

    /// The seek tolerance is at its most accurate.
    public func seek(to time: MediaTime) {
        let cmTime = CMTime(mediaTime: time)
        
        player.seek(to: cmTime,
                    toleranceBefore: .zero,
                    toleranceAfter: .zero)
    }

    public func cancelPendingSeeks() {
        player.currentItem?.cancelPendingSeeks()
    }

    public var mediaCanStepForward: Bool {
        player.currentItem?.canStepForward ?? false
    }

    public var mediaCanStepBackward: Bool {
        player.currentItem?.canStepBackward ?? false
    }

    public func step(byFrames count: Int) {
        player.currentItem?.step(byCount: count)
    }

    public func setVideoPlayer(view: PlayerView) {
        view.player = player
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
