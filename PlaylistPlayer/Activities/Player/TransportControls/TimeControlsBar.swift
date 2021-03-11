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
                viewModel.scrubbed(to: Time(seconds: Double($0)))
            }
        )

        VStack(spacing: 0) {
            CustomSlider(value: currentTimeSeconds,
                         in: 0...CGFloat(viewModel.duration.seconds),
                         configuration: sliderConfiguration,
                         onDragStart: { viewModel.scrubbingDidStart() },
                         onDragFinish: { viewModel.scrubbingDidEnd() })
            HStack {
                Text(viewModel.formattedCurrentTime)
                Spacer()
                Text(viewModel.formattedDuration)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }

    private var sliderConfiguration: CustomSlider.Configuration {
        CustomSlider.Configuration(knobWidth: 20,
                                   minimumTrackTint: .white,
                                   maximumTrackTint: .secondary)
    }
}
