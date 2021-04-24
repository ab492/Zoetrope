//
//  UIPlayerView.swift
//  Quickfire
//
//  Created by Andy Brown on 13/12/2020.
//

import UIKit
import AVFoundation

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    private var videoRectObserver: NSKeyValueObservation?

    // MARK: - Init

    init(player: AVPlayer) {
        super.init(frame: .zero)
        self.player = player

        videoRectObserver = player.currentItem?.observe(\.status, changeHandler: { item, _ in
            DispatchQueue.main.async {
                print("CHANGE!")
            }
        })

//        videoRectObserver = playerLayer.observe(\.videoRect) { [weak self] layer, newRect in
//            DispatchQueue.main.async {
//                print("PLAYER: \(newRect)")
//            }
//        }
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PlayerLayer Overrides

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }


}
