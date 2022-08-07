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
    
    public init(minute: Double, preferredTimescale: CMTimeScale = .default) {
        self.init(seconds: minute * 60, preferredTimescale: preferredTimescale)
    }
    
    public init(hour: Double, preferredTimescale: CMTimeScale = .default) {
        self.init(minute: hour * 60, preferredTimescale: preferredTimescale)
    }

    public init(time: CMTime) {
        self.cmTime = time
    }
}

extension CMTime {
    public init(mediaTime: MediaTime) {
        self.init(value: mediaTime.cmTime.value, timescale: mediaTime.cmTime.timescale)
    }
}

extension MediaTime: Comparable {
    public static func < (lhs: MediaTime, rhs: MediaTime) -> Bool {
        lhs.cmTime < rhs.cmTime
    }
}

extension MediaTime {
    public static func + (lhs: MediaTime, rhs: MediaTime) -> MediaTime {
        MediaTime(seconds: lhs.seconds + rhs.seconds)
    }
    
    public static func - (lhs: MediaTime, rhs: MediaTime) -> MediaTime {
        MediaTime(seconds: lhs.seconds - rhs.seconds)
    }
}

extension MediaTime: Codable { }

extension MediaTime {
    public static let zero: MediaTime = MediaTime(seconds: 0)
}

extension CMTimeScale {
    public static let `default`: CMTimeScale = 600
}

extension MediaTime: CustomStringConvertible {
    public var description: String {
        "Seconds: \(seconds). Timescale: \(cmTime.timescale)"
    }
}
