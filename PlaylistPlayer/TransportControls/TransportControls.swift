//
//  TransportControls.swift
//  Quickfire
//
//  Created by Andy Brown on 16/12/2020.
//

import SwiftUI
import AVFoundation

struct TransportControls: View {

    // MARK: - State

    @StateObject var viewModel: PlaylistPlayerViewModel
    
    // MARK: - View

    var body: some View {
        let loopMode = Binding<PlaylistPlayer.LoopMode>(
            get: {
                self.viewModel.loopMode
            },
            set: {
                self.viewModel.setLoopMode(to: $0)
            }
        )

        VStack {
            PlaybackControlsBar(configuration: configuration(),
                                isPlaying: viewModel.isPlaying,
                                canPlayFastReverse: viewModel.canPlayFastReverse,
                                canPlayFastForward: viewModel.canPlayFastForward)
            TimeControlsBar(loopMode: loopMode)
        }
        .padding()
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark)))
        .cornerRadius(5)
        .frame(minWidth: 400, idealWidth: 400, maxWidth: 700)
    }

    private func configuration() -> PlaybackControlsBar.Configuration {
        return PlaybackControlsBar.Configuration(onPreviousItem: viewModel.previousItem,
                                                 onFastReverse: { },
                                                 onSkipBackwards: { viewModel.step(byFrames: -1) },
                                                 onPlayPause: { viewModel.isPlaying ? viewModel.pause() : viewModel.play() },
                                                 onSkipForwards: { viewModel.step(byFrames: 1) },
                                                 onFastForward: { },
                                                 onNextItem: viewModel.nextItem)
    }
}
