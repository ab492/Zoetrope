//
//  VideoPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import Combine
import VideoQueuePlayer

struct VideoPlayerView: UIViewRepresentable {

    // MARK: - Properties

    @ObservedObject var playerViewModel: PlaylistPlayerViewModel

    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        playerViewModel.setVideoPlayer(view: view)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) { }
}
