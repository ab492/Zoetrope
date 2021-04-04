//
//  VideoPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct VideoPlayerView: UIViewRepresentable {
    let player: PlaylistPlayerViewModel

    init(player: PlaylistPlayerViewModel) {
        self.player = player
    }
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        player.setVideoPlayer(view: view)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) { }
}
