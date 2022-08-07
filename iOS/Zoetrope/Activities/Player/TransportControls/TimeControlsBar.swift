//
//  TimeControlsBar.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 24/01/2021.
//

import SwiftUI
import VideoQueuePlayer

struct TimeControlsBar: View {

    @ObservedObject var viewModel: PlaylistPlayerViewModel

    /// As debugging the scrubber bar is tricky due to various layers and tap areas, enable the ui debug flag to help visually highlight layers.
    private let uiDebug = false

    var body: some View {

        let currentTimeSeconds = Binding<CGFloat>(
            get: {
                return CGFloat(viewModel.currentTime.seconds)
            },
            set: {
                viewModel.scrubbed(to: MediaTime(seconds: Double($0)))
            }
        )

        // ZIndex and negative spacing required here to allow for a larger tap area on the knob.
        // Use `uiDebug` flag to see the issue.
        ZStack {
            VStack(spacing: -14) {
                CustomSlider(value: currentTimeSeconds,
                             in: 0...CGFloat(viewModel.duration.seconds),
                             configuration: sliderConfiguration,
                             uiDebug: uiDebug,
                             onDragStart: { viewModel.scrubbingDidStart() },
                             onDragFinish: { viewModel.scrubbingDidEnd() })
                    .zIndex(1)
                HStack {
                    Text(viewModel.formattedCurrentTime)
                    Spacer()
                    Text(viewModel.formattedDuration)
                }
                .zIndex(0)
                .background(uiDebug ? Color.red : Color.clear)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Current position")
        .accessibilityValue(Text(viewModel.currentTimeAccessibilityLabel))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: viewModel.accessibilityIncrement()
            case .decrement: viewModel.accessibilityDecrement()
            @unknown default: break
            }
        }
    }

    private var sliderConfiguration: CustomSlider.Configuration {
        CustomSlider.Configuration(knobWidth: 20,
                                   minimumTrackTint: .white,
                                   maximumTrackTint: .secondary)
    }
}
