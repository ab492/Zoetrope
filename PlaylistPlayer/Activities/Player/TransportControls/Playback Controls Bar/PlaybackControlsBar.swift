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

        let loopMode = Binding<LoopMode>(
            get: {
                return viewModel.loopMode
            },
            set: {
                viewModel.setLoopMode(to: $0)
            }
        )

        HStack {
            LoopButton(loopMode: loopMode)
            Spacer()
            corePlaybackControls
            Spacer()
            EllipsisButton()
        }
    }

    private var corePlaybackControls: some View {
        Group {
            previousItemButton
            fastReverseButton
            skipBackwardsButton
            playPauseButton
            skipForwardsButton
            fastForwardButton
            nextItemButton
        }
    }

    private var previousItemButton: some View {
        Button {
            viewModel.previousItem()
        } label: {
            Image(systemName: PlayerIcons.previousItem)
                .font(.largeTitle)
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibility(label: Text("Previous video"))
    }

    private var fastReverseButton: some View {
        Button {
            viewModel.playFastReverse()
        } label: {
            Image(systemName: PlayerIcons.fastReverse)
                .font(.largeTitle)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(fastReverseButtonDisabled)
        .accessibility(label: Text("Fast backward")) // TODO: Fix this with a speed!
    }

    private var skipBackwardsButton: some View {
        Button {
            viewModel.step(byFrames: -1)
        } label: {
            Image(systemName: PlayerIcons.skipBackwards)
                .font(.largeTitle)
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibility(label: Text("Skip 1 frame backward"))
    }

    private var playPauseButton: some View {
        Button {
            viewModel.isPlaying ? viewModel.pause() : viewModel.play()
        } label: {
            Image(systemName: viewModel.isPlaying ? PlayerIcons.pause : PlayerIcons.play)
                .font(.system(size: 52))
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibility(label: Text(viewModel.isPlaying ? "Pause" : "Play"))
    }

    private var skipForwardsButton: some View {
        Button {
            viewModel.step(byFrames: 1)
        } label: {
            Image(systemName: PlayerIcons.skipForwards)
                .font(.largeTitle)
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibility(label: Text("Skip 1 frame forward"))
    }

    private var fastForwardButton: some View {
        Button {
            viewModel.playFastForward()
        } label: {
            Image(systemName: PlayerIcons.fastForward)
                .font(.largeTitle)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(fastForwardButtonDisabled)
        .accessibility(label: Text("Fast forward")) // TODO: Fix this with a speed!
    }

    private var nextItemButton: some View {
        Button {
            viewModel.nextItem()
        } label: {
            Image(systemName: PlayerIcons.nextItem)
                .font(.largeTitle)
        }
        .buttonStyle(ScaleButtonStyle())
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
