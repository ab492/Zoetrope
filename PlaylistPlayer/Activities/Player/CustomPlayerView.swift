//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct CustomPlayerView: View {

    @StateObject var viewModel: PlaylistPlayerViewModel
    @State private var showTransportControls = false

    var body: some View {
        ZStack {
            videoPlaybackView.zIndex(0)
            transportControls.zIndex(1)
        }
        .statusBar(hidden: false)
        .onAppear { viewModel.play() }
        .onDisappear { viewModel.pause() }
    }

    private var videoPlaybackView: some View {
        CustomPlayerLayer(viewModel: viewModel)
            .onTapGesture { withAnimation(.easeIn(duration: 0.1)) { showTransportControls.toggle() }}
    }

    @ViewBuilder
    private var transportControls: some View {
        if showTransportControls { TransportControls(viewModel: viewModel) }
    }
}
