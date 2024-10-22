//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

/// Represents the actual video player (without transport controls) content.
struct CustomPlayerLayer: View {

    @ObservedObject var viewModel: PlaylistPlayerViewModel

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            if viewModel.isReadyForPlayback {
                VideoPlayerView(playerViewModel: viewModel)
            } else {
                loadingSpinner
            }
        }
    }
    
    private var loadingSpinner: some View {
        ProgressView()
            .scaleEffect(1.5, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
    }
}
