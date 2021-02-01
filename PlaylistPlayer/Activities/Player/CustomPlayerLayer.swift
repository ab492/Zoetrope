//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

/// Represents the actual video player (without transport controls) content.
struct CustomPlayerLayer: View {

    @StateObject var viewModel: PlaylistPlayerViewModel

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            if viewModel.isReadyForPlayback {
                // FIXME: Fix this force unwrap!
                VideoPlayerView(player: viewModel.player.player as! WrappedAVQueuePlayer)
            } else {
                loadingSpinner
            }
        }
        .edgesIgnoringSafeArea(.all)
//        .statusBar(hidden: true)
    }

    private var loadingSpinner: some View {
        ProgressView()
            .scaleEffect(1.5, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
    }
}
