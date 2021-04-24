//
//  VideoPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import Combine

struct VideoPlayerView: UIViewRepresentable {
    let player: PlaylistPlayerViewModel


    private var cancellables = Set<AnyCancellable>()

//    private var canc: AnyCancellable!


    init(player: PlaylistPlayerViewModel) {
        self.player = player

        // https://stackoverflow.com/questions/59689442/passing-an-observableobject-model-through-another-obobject

        self.player.objectWillChange.sink {
//            print("HERE?: \(player.videoSize?())")
        }.store(in: &cancellables)



    }
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        player.setVideoPlayer(view: view)
        player.videoSize = {
            view.playerLayer.videoRect
        }
//        view.playerLayer.backgroundColor = UIColor.lightGray.cgColor

//        self.player.objectWillChange.sink {
//            print("HERE?")
//            print(view.playerLayer.videoRect)
//        }

        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) { }
}
