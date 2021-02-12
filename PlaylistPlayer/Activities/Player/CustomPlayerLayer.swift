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
            Color.green.edgesIgnoringSafeArea(.all)
            if viewModel.isReadyForPlayback {
                // FIXME: Fix this force unwrap!
                VideoPlayerView(player: (viewModel.player as! PlaylistPlayer).player as! WrappedAVPlayer)
            } else {
                loadingSpinner
            }
        }
        .edgesIgnoringSafeArea(.all)
//        .onTapGesture {
//            print("Tapping!")
//        }
//        .statusBar(hidden: true)
    }

    private var loadingSpinner: some View {
        ProgressView()
            .scaleEffect(1.5, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .background(Color.red)
    }
}
