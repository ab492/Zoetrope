//  PlaybackControlBar.swift
//  Quickfire
//
//  Created by Andy Brown on 15/12/2020.
//

import SwiftUI

struct PlaybackControlsBar: View {

    @StateObject var viewModel: PlaylistPlayerViewModel
    
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
        PlaybackControlsButton(systemImage: PlayerIcons.previousItem) {
            viewModel.previousItem()
        }
        .accessibility(label: Text("Previous video"))
    }

    private var fastReverseButton: some View {
        PlaybackControlsButton(systemImage: PlayerIcons.fastReverse) {
            // TODO
        }
        .disabled(fastReverseButtonDisabled)
        .foregroundColor(fastReverseButtonDisabled ? .gray : .white)
        .accessibility(label: Text("Fast backward")) // TODO: Fix this with a speed!
    }

    private var skipBackwardsButton: some View {
        PlaybackControlsButton(systemImage: PlayerIcons.skipBackwards) {
            viewModel.step(byFrames: -1)
        }
        .accessibility(label: Text("Skip 1 frame backward"))
    }

    private var playPauseButton: some View {
        PlaybackControlsButton(systemImage: viewModel.isPlaying ? PlayerIcons.pause : PlayerIcons.play) {
            viewModel.isPlaying ? viewModel.pause() : viewModel.play()
        }
        .accessibility(label: Text(viewModel.isPlaying ? "Pause" : "Play"))
    }

    private var skipForwardsButton: some View {
        PlaybackControlsButton(systemImage: PlayerIcons.skipForwards) {
            viewModel.step(byFrames: 1)
        }
        .foregroundColor(fastForwardButtonDisabled ? .gray : .white)
        .accessibility(label: Text("Skip 1 frame forward"))
    }

    private var fastForwardButton: some View {
        PlaybackControlsButton(systemImage: PlayerIcons.fastForward) {
            // TODO
        }
        .disabled(fastForwardButtonDisabled)
        .accessibility(label: Text("Fast forward")) // TODO: Fix this with a speed!
    }

    private var nextItemButton: some View {
        PlaybackControlsButton(systemImage: PlayerIcons.nextItem) {
            viewModel.nextItem()
        }
        .accessibility(label: Text("Next video"))
    }

}

// MARK: - Icons and Helpers

extension PlaybackControlsBar {

    private var fastReverseButtonDisabled: Bool {
        viewModel.canPlayFastReverse == false
    }

    private var fastForwardButtonDisabled: Bool {
        viewModel.canPlayFastForward == false
    }
    
}
