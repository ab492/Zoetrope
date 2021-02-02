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
        VStack {
            PlaybackControlsBar(viewModel: viewModel)
            TimeControlsBar(viewModel: viewModel)
        }
        .padding()
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark)))
        .cornerRadius(5)
        .frame(minWidth: 400, idealWidth: 400, maxWidth: 700)
        .offset(y: -10)
    }

    private var closeButton: some View {
        PlaybackControlsButton(systemImage: PlayerIcons.close) {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(.white)
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark)))
        .cornerRadius(5)
        .offset(x: 10, y: 10)
        .accessibility(label: Text("Close player"))
    }
}
