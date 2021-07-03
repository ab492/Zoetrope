import Foundation
import CoreMedia

// Developer docs regarding timescales:
// https://developer.apple.com/library/archive/qa/qa1447/_index.html

/// An accurate representation of time used for media timings where precision is key. Wraps `CMTime`.
public struct MediaTime {
    fileprivate var cmTime: CMTime

    public var seconds: Double {
        CMTimeGetSeconds(cmTime)
    }

    public init(seconds: Double, preferredTimescale: CMTimeScale = .default) {
        cmTime = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
    }

    public init(time: CMTime) {
        self.cmTime = time
    }
}

public extension CMTime {
    init(mediaTime: MediaTime) {
        self.init(value: mediaTime.cmTime.value, timescale: mediaTime.cmTime.timescale)
    }
}

extension MediaTime: Comparable {
    public static func < (lhs: MediaTime, rhs: MediaTime) -> Bool {
        lhs.cmTime < rhs.cmTime
    }
}

extension MediaTime: Codable { }

public extension MediaTime {
    static let zero: MediaTime = MediaTime(seconds: 0)
}

public extension CMTimeScale {
    static let `default`: CMTimeScale = 600
}
