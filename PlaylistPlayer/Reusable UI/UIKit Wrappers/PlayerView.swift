//
//  UIPlayerView.swift
//  Quickfire
//
//  Created by Andy Brown on 13/12/2020.
//

import UIKit
import AVFoundation

final class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
