//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct CustomPlayerView: View {

    @StateObject var viewModel: PlaylistPlayerViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            CustomPlayerLayer(viewModel: viewModel)
            TransportControls(viewModel: viewModel)
        }
        .onAppear { viewModel.play() }
    }
}
