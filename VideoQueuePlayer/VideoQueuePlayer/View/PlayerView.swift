//
//  UIPlayerView.swift
//  Quickfire
//
//  Created by Andy Brown on 13/12/2020.
//

import UIKit
import AVFoundation

final public class PlayerView: UIView {
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    public override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
