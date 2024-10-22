//
//  PlayerViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import AVFoundation
import Combine
import SwiftUI
import VideoQueuePlayer

final class PlaylistPlayerViewModel: ObservableObject {

    // MARK: - Types
    
    enum ShowControlsTime: Int, CaseIterable, Identifiable {
        case three = 3
        case five = 5
        case ten = 10
        
        var label: String {
            "\(self.rawValue)s" // 3s
        }
        
        var id: String {
            "\(self.rawValue)"
        }
    }

    // MARK: - Properties
    
    private var playlistPlayer: PlaylistPlayer

    @Published private(set) var isPlaying = false
    @Published private(set) var isReadyForPlayback = false
    @Published private(set) var canPlayFastReverse = false
    @Published private(set) var canPlayFastForward = false
    
    @Published private(set) var currentTime: MediaTime = .zero
    @Published private(set) var duration: MediaTime = .zero
    @Published private(set) var formattedCurrentTime = "00:00"
    @Published private(set) var formattedDuration = "00:00"
    @Published private(set) var showTransportControls = true
    private var showSettings = false
    private let timeFormatter = TimeFormatter()
    private lazy var timer = Timer.publish(every: TimeInterval(showControlsTime.rawValue), on: .main, in: .common)
    
    var currentTimeAccessibilityLabel: String {
        "\(timeFormatter.accessibilityString(from: .init(mediaTime: currentTime))) of \(timeFormatter.accessibilityString(from: .init(mediaTime: duration)))"
    }
    
    private var timerSubscription: Cancellable?
    
    var useControlsTimer: Bool {
        get {
            guard Current.accessibilityService.isVoiceoverEnabled == false else { return false }
            return Current.userPreferencesManager.useControlsTimer
        }
        set {
            objectWillChange.send()
            Current.userPreferencesManager.useControlsTimer = newValue
            invalidateAutoHideTimer(andRestartIt: useControlsTimer)
        }
    }
    
    var showControlsTime: ShowControlsTime {
        get {
            let preference = Current.userPreferencesManager.showControlsTime
            return ShowControlsTime(rawValue: preference) ?? .three
        } set {
            objectWillChange.send()
            Current.userPreferencesManager.showControlsTime = newValue.rawValue
            // Update the timer to use the new time
            timer = Timer.publish(every: TimeInterval(showControlsTime.rawValue), on: .main, in: .common)
            invalidateAutoHideTimer(andRestartIt: true)
        }
    }
    
    private var playlist: Playlist?

    var currentlyPlayingVideo: VideoModel? {
        playlistPlayer.currentlyPlayingVideo
    }

    var videoTitle: String {
        currentlyPlayingVideo?.displayName ?? ""
    }

    var loopMode: LoopMode {
        get {
            playlistPlayer.loopMode
        }
        set {
            objectWillChange.send()
            playlistPlayer.loopMode = newValue
        }
    }
    
    // MARK: - Init

    init(playlistPlayer: PlaylistPlayer) {
        self.playlistPlayer = playlistPlayer
        self.loopMode = Current.userPreferencesManager.loopMode
        self.playlistPlayer.addObserver(self)
    }

    convenience init() {
        self.init(playlistPlayer: PlaylistPlayerImpl())
    }

    // MARK: - Public

    func play() {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.play()
    }

    func pause() {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.pause()
    }

    func nextItem() {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.nextItem()
    }

    func previousItem() {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.previousItem()
    }

    func skipToItem(at index: Int) {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.skipToItem(at: index)
    }

    func step(byFrames frames: Int) {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.step(byFrames: frames)
    }
    
    func seek(to time: MediaTime) {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.seek(to: time)
    }

    func updateQueue(for playlist: Playlist) {
        playlistPlayer.updateQueue(for: playlist)
    }
    
    func didTapVideo() {
        if useControlsTimer {
            if showTransportControls {
                showTransportControls = false
            } else {
                invalidateAutoHideTimer(andRestartIt: true)
            }
        } else {
            showTransportControls.toggle()
        }
    }
    
    func didTapSettings(show: Bool) {
        showSettings = show
        invalidateAutoHideTimer(andRestartIt: true)
    }

    // MARK: - Scrubbing

    func scrubbingDidStart() {
        playlistPlayer.scrubbingDidStart()
    }

    func scrubbingDidEnd() {
        playlistPlayer.scrubbingDidEnd()
    }

    func scrubbed(to time: MediaTime) {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.scrubbed(to: time)
    }
  
    /**
     Used for when a VoiceOver user swipes up to scrub through media. The increment time depends on the length of the content:
     ## Increments:
     - Duration less than 5 minutes: 5 second increment
     - Duration between 5 minutes and 1 hour: 5 minute increment
     - Duration greater than 1 hour: 10 minute increment
     - Note: If next increment would be greater than the duration, this method returns with no action.
     */
    func accessibilityIncrement() {
        invalidateAutoHideTimer(andRestartIt: true)
        
        let newTime: MediaTime
        if duration < MediaTime(minute: 5) {
            newTime = (currentTime + MediaTime(seconds: 5))
        } else if duration < MediaTime(hour: 1) {
            newTime = (currentTime + MediaTime(minute: 5))
        } else {
            newTime = (currentTime + MediaTime(minute: 10))
        }
                
        guard newTime < duration else { return }
        playlistPlayer.seek(to: newTime)
    }
    
    /**
     Used for when a VoiceOver user swipes down to scrub through media. The decrement time depends on the length of the content:
     ## Increments:
     - Duration less than 5 minutes: 5 second decrement
     - Duration between 5 minutes and 1 hour: 5 minute decrement
     - Duration greater than 1 hour: 10 minute decrement
     - Note: If next decrement would be les than zero, we seek to zero.
     */
    func accessibilityDecrement() {
        invalidateAutoHideTimer(andRestartIt: true)
        
        let newTime: MediaTime
        if duration < MediaTime(minute: 5) {
            newTime = (currentTime - MediaTime(seconds: 5))
        } else if duration < MediaTime(hour: 1) {
            newTime = (currentTime - MediaTime(minute: 5))
        } else {
            newTime = (currentTime - MediaTime(minute: 10))
        }
        
        playlistPlayer.seek(to: newTime.constrained(min: .zero))
    }

    // MARK: - Playback Rate

    func playFastForward() {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.playFastForward()
    }

    func playFastReverse() {
        invalidateAutoHideTimer(andRestartIt: true)
        playlistPlayer.playFastReverse()
    }
    
    // MARK: - PlayerView

    func setVideoPlayer(view: PlayerView) {
        playlistPlayer.setVideoPlayer(view: view)
    }
    
    // MARK: - Private
    
    private func invalidateAutoHideTimer(andRestartIt restart: Bool) {
        timerSubscription = nil
        
        guard useControlsTimer else { return }
        
        if restart {
            showTransportControls = true
            timerSubscription = timer.autoconnect().sink(receiveValue: { [weak self] _ in
                // Don't hide the controls if the settings panel is showing
                guard self?.showSettings == false else { return }
                
                self?.showTransportControls = false
                self?.timerSubscription = nil
            })
        }
    }

}

// MARK: - PlaylistPlayerObserver

extension PlaylistPlayerViewModel: PlaylistPlayerObserver {

    func loopModeDidUpdate(newValue: LoopMode) {
        objectWillChange.send()
    }

    func playbackReadinessDidChange(isReady: Bool) {
        isReadyForPlayback = isReady
    }

    func playbackFastReverseAbilityDidChange(canPlayFastReverse: Bool) {
        self.canPlayFastReverse = canPlayFastReverse
    }

    func playbackFastForwardAbilityDidChange(canPlayFastForward: Bool) {
        self.canPlayFastForward = canPlayFastForward
    }

    func playbackDurationDidChange(to time: MediaTime) {
        self.duration = time
        self.formattedDuration = timeFormatter.string(from: Int(time.seconds))
    }

    func playbackStateDidChange(to playPauseState: PlayPauseState) {
        switch playPauseState {
        case .paused: isPlaying = false
        case .playing: isPlaying = true
        }
    }

    func playbackPositionDidChange(to time: MediaTime) {
        currentTime = time
        formattedCurrentTime = timeFormatter.string(from: Int(time.seconds))
    }
}
