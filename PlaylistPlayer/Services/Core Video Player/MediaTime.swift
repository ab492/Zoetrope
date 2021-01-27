import Foundation
import CoreMedia

/// An accurate representation of time used for media timings where precision is key. Wraps `CMTime`.
struct MediaTime {
    private var cmTime: CMTime

    var seconds: Double {
        CMTimeGetSeconds(cmTime)
    }

    let preferredTimescale: CMTimeScale

    init(seconds: Double, preferredTimescale: CMTimeScale = .default) {
        self.preferredTimescale = preferredTimescale
        cmTime = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
    }
}

extension CMTimeScale {
    static let `default`: CMTimeScale = 600
}

extension MediaTime {
    static let zero: MediaTime = MediaTime(seconds: 0)
}
