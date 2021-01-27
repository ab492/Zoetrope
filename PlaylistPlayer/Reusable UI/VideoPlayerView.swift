//
//  VideoPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct VideoPlayerView: UIViewRepresentable {
    let player: WrappedAVQueuePlayer

    init(player: WrappedAVQueuePlayer) {
        self.player = player
    }

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.setVideoPlayer(player)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) { }
}
