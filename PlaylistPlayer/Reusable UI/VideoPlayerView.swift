//
//  VideoPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct VideoPlayerView: UIViewRepresentable {
    let player: WrappedAVPlayer

    init(player: WrappedAVPlayer) {
        self.player = player
    }

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.setVideoPlayer(player)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) { }
}
