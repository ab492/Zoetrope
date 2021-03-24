import Foundation
import CoreMedia

// Developer docs regarding timescales:
// https://developer.apple.com/library/archive/qa/qa1447/_index.html

/// An accurate representation of time used for media timings where precision is key. Wraps `CMTime`.
struct MediaTime {
    private var cmTime: CMTime
    let preferredTimescale: CMTimeScale

    var seconds: Double {
        CMTimeGetSeconds(cmTime)
    }

    init(seconds: Double, preferredTimescale: CMTimeScale = .default) {
        self.preferredTimescale = preferredTimescale
        cmTime = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
    }

    init(time: CMTime) {
        self.cmTime = time
        self.preferredTimescale = time.timescale
    }
}

extension MediaTime: Comparable {
    static func < (lhs: MediaTime, rhs: MediaTime) -> Bool {
        lhs.cmTime < rhs.cmTime
    }
}

extension MediaTime: Codable { }

extension MediaTime {
    static let zero: MediaTime = MediaTime(seconds: 0)
}

extension CMTimeScale {
    static let `default`: CMTimeScale = 600
}
