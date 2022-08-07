//
//  WrappedAVPlayerItem.swift
//  VideoQueuePlayer
//
//  Created by Andy Brown on 07/08/2022.
//

import AVFoundation

public final class WrappedAVPLayerItem: PlayerItem {
    
    // MARK: - Propeties

    fileprivate let playerItem: AVPlayerItem
    public let url: URL
    
    // MARK: - Init

    public init(url: URL) {
        self.playerItem = AVPlayerItem(url: url)
        self.url = url
    }
    
    public init(asset: AVURLAsset) {
        self.playerItem = AVPlayerItem(asset: asset)
        self.url = asset.url
    }
    
    // MARK: - Public

    public func seek(to time: MediaTime) {
        playerItem.seek(to: CMTime(mediaTime: time), completionHandler: nil)
    }
    
    public func isSame(as other: PlayerItem) -> Bool {
        guard let otherAsAVPlayerItem = other as? WrappedAVPLayerItem else { return false }
        return playerItem == otherAsAVPlayerItem.playerItem
    }
}

extension AVPlayer {
    func replaceCurrentItem(with item: WrappedAVPLayerItem) {
        replaceCurrentItem(with: item.playerItem)
    }
}
