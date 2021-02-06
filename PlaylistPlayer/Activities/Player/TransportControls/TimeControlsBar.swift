//
//  TimeControlsBar.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 24/01/2021.
//

import SwiftUI

struct TimeControlsBar: View {

    @StateObject var viewModel: PlaylistPlayerViewModel
    
    var body: some View {

        let currentTimeSeconds = Binding<CGFloat>(
            get: {
                return CGFloat(viewModel.currentTime.seconds)
            },
            set: {
                print("SETTING SLIDER VALUE: \(Double($0))")
                viewModel.scrubbed(to: Time(seconds: Double($0)))
            }
        )

        HStack {
            Text(viewModel.formattedCurrentTime)
                .foregroundColor(.white)
            CustomSlider(value: currentTimeSeconds,
                         in: 0...CGFloat(viewModel.duration.seconds),
                         configuration: sliderConfiguration,
                         onDragStart: { viewModel.scrubbingDidStart() },
                         onDragFinish: { viewModel.scrubbingDidEnd() })
            Text(viewModel.formattedDuration)
                .foregroundColor(.white)
            loopButton
        }
    }

    // FIXME: Fix accessibility for this label.
    @ViewBuilder
    private var loopButton: some View {
        switch viewModel.loopMode {
        case .loopCurrent:
            PlaybackControlsButton(systemImage: PlayerIcons.loopCurrent, onTap: { viewModel.setLoopMode(to: .playPlaylistOnce) })
                .foregroundColor(.white)
        case .loopPlaylist:
            PlaybackControlsButton(systemImage: PlayerIcons.loopPlaylist, onTap: { viewModel.setLoopMode(to: .loopCurrent) })
                .foregroundColor(.white)
        case .playPlaylistOnce:
            PlaybackControlsButton(systemImage: PlayerIcons.loopPlaylist, onTap: { viewModel.setLoopMode(to: .loopPlaylist) })
                .foregroundColor(.gray)
        }
    }
    
    private var sliderConfiguration: CustomSlider.Configuration {
        CustomSlider.Configuration(knobWidth: 25,
                                   minimumTrackTint: .white,
                                   maximumTrackTint: .gray)
    }
}
