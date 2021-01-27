//  PlaybackControlBar.swift
//  Quickfire
//
//  Created by Andy Brown on 15/12/2020.
//

import SwiftUI

struct PlaybackControlsBar: View {

    // MARK: - Configuration

    struct Configuration {
        var onPreviousItem: () -> Void
        var onFastReverse: () -> Void
        var onSkipBackwards: () -> Void
        var onPlayPause: () -> Void
        var onSkipForwards: () -> Void
        var onFastForward: () -> Void
        var onNextItem: () -> Void
    }

    var configuration: Configuration

    // MARK: - State

    var isPlaying: Bool
    var canPlayFastReverse: Bool
    var canPlayFastForward: Bool

    // MARK: - View

    var body: some View {
        HStack {
            Group {
                previousItemButton
                fastReverseButton
                skipBackwardsButton
                playPauseButton
                skipForwardsButton
                fastForwardButton
                nextItemButton
            }
            .foregroundColor(.white)
        }
    }

    private var previousItemButton: some View {
        PlaybackControlsButton(systemImage: Icons.previousItem, onTap: configuration.onPreviousItem)
            .accessibility(label: Text("Previous video"))
    }

    private var fastReverseButton: some View {
        PlaybackControlsButton(systemImage: Icons.fastReverse, onTap: configuration.onFastReverse)
            .disabled(fastReverseButtonDisabled)
            .foregroundColor(fastReverseButtonDisabled ? .gray : .white)
            .accessibility(label: Text("Fast backward")) // TODO: Fix this with a speed!
    }

    private var skipBackwardsButton: some View {
        PlaybackControlsButton(systemImage: Icons.skipBackwards, onTap: configuration.onSkipBackwards)
            .accessibility(label: Text("Skip 1 frame backward"))
    }

    private var playPauseButton: some View {
        PlaybackControlsButton(systemImage: isPlaying ? Icons.pause : Icons.play, onTap: configuration.onPlayPause)
            .accessibility(label: Text(isPlaying ? "Pause" : "Play"))
    }

    private var skipForwardsButton: some View {
        PlaybackControlsButton(systemImage: Icons.skipForwards, onTap: configuration.onSkipForwards)
            .foregroundColor(fastForwardButtonDisabled ? .gray : .white)
            .accessibility(label: Text("Skip 1 frame forward"))
    }

    private var fastForwardButton: some View {
        PlaybackControlsButton(systemImage: Icons.fastForward, onTap: configuration.onFastForward)
            .disabled(fastForwardButtonDisabled)
            .accessibility(label: Text("Fast forward")) // TODO: Fix this with a speed!
    }

    private var nextItemButton: some View {
        PlaybackControlsButton(systemImage: Icons.nextItem, onTap: configuration.onNextItem)
            .accessibility(label: Text("Next video"))
    }

}

// MARK: - Icons and Helpers

extension PlaybackControlsBar {

    private struct Icons {
        static let play = "play.fill"
        static let pause = "pause.fill"
        static let fastReverse = "backward.fill"
        static let fastForward = "forward.fill"
        static let skipBackwards = "backward.frame.fill"
        static let skipForwards = "forward.frame.fill"
        static let nextItem = "forward.end.fill"
        static let previousItem = "backward.end.fill"
    }

    private var fastReverseButtonDisabled: Bool {
        canPlayFastReverse == false
    }

    private var fastForwardButtonDisabled: Bool {
        canPlayFastForward == false
    }
    
}
