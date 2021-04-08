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

    @Binding var playerOptionsIsSelected: Bool
    @ObservedObject var viewModel: PlaylistPlayerViewModel
    @Environment(\.presentationMode) var presentationMode

    // MARK: - View

    var body: some View {
        VStack {
            topBar
                .offset(y: 25)
            Spacer()
            playbackControls
        }
    }

    private var playbackControls: some View {
        VStack(spacing: 0) {
            TimeControlsBar(viewModel: viewModel)
            PlaybackControlsBar(playerOptionsIsSelected: $playerOptionsIsSelected, viewModel: viewModel)
        }
        .padding()
        .frame(width: 600)
        .drawingGroup() // Added to boost rendering. Must occur before the background blur.
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
        .cornerRadius(10)
        .offset(y: -10)
    }

    private var topBar: some View {
        HStack(alignment: .center) {
            closeButton
                .offset(x: 10)
            Spacer()
            Text(viewModel.videoTitle)
                .font(.headline)
            Spacer()
        }
    }

    private var closeButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: PlayerIcons.Playback.close)
                .font(.title)
        }
        .buttonStyle(ScaleButtonStyle(width: 45, height: 45))
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
        .cornerRadius(10)
        .accessibility(label: Text("Close player"))
    }
}
