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
    @Environment(\.presentationMode) var presentationMode

    // MARK: - View

    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            Spacer()
            playbackControls

        }
    }

    private var playbackControls: some View {
        VStack(spacing: 0) {
            TimeControlsBar(viewModel: viewModel)
            PlaybackControlsBar(viewModel: viewModel)
        }
        .padding()
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
        .cornerRadius(10)
        .frame(width: 600)
        .offset(y: -10)

    }

    private var closeButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: PlayerIcons.close)
                .font(.title)
        }
        .buttonStyle(ScaleButtonStyle(width: 45, height: 45))
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
        .cornerRadius(10)
        .offset(x: 10, y: 25)
        .accessibility(label: Text("Close player"))
    }
}
