//
//  PlayerViewProtocol.swift
//  VideoQueuePlayer
//
//  Created by Andy Brown on 01/07/2021.
//

import Foundation
import AVFoundation
import UIKit

public protocol PlayerViewProtocol: UIView {
    var player: AVPlayer? { get set }
    var playerLayer: AVPlayerLayer { get }
}

// TODO: What to do about this crash?

//public extension PlayerViewProtocol {
//    
//    var player: AVPlayer? {
//        get {
//            return playerLayer.player
//        }
//        set {
//            playerLayer.player = newValue
//        }
//    }
//
//    var playerLayer: AVPlayerLayer {
//        return layer as! AVPlayerLayer
//    }
//
//    static var layerClass: AnyClass {
//        return AVPlayerLayer.self
//    }
//}



