import Foundation
import CoreMedia

// Developer docs regarding timescales:
// https://developer.apple.com/library/archive/qa/qa1447/_index.html

/// An accurate representation of time used for media timings where precision is key. Wraps `CMTime`.
struct MediaTime {
    fileprivate var cmTime: CMTime

    var seconds: Double {
        CMTimeGetSeconds(cmTime)
    }

    init(seconds: Double, preferredTimescale: CMTimeScale = .default) {
        cmTime = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
    }
    
    init(minute: Double, preferredTimescale: CMTimeScale = .default) {
        self.init(seconds: minute * 60, preferredTimescale: preferredTimescale)
    }
    
    init(hour: Double, preferredTimescale: CMTimeScale = .default) {
        self.init(minute: hour * 60, preferredTimescale: preferredTimescale)
    }

    init(time: CMTime) {
        self.cmTime = time
    }
}

extension CMTime {
    init(mediaTime: MediaTime) {
        self.init(value: mediaTime.cmTime.value, timescale: mediaTime.cmTime.timescale)
    }
}

extension MediaTime: Comparable {
    static func < (lhs: MediaTime, rhs: MediaTime) -> Bool {
        lhs.cmTime < rhs.cmTime
    }
}

extension MediaTime {
    static func + (lhs: MediaTime, rhs: MediaTime) -> MediaTime {
        MediaTime(seconds: lhs.seconds + rhs.seconds)
    }
    
    static func - (lhs: MediaTime, rhs: MediaTime) -> MediaTime {
        MediaTime(seconds: lhs.seconds - rhs.seconds)
    }
}

extension MediaTime: Codable { }

extension MediaTime {
    static let zero: MediaTime = MediaTime(seconds: 0)
}

extension CMTimeScale {
    static let `default`: CMTimeScale = 600
}

extension MediaTime: CustomStringConvertible {
    var description: String {
        "Seconds: \(seconds). Timescale: \(cmTime.timescale)"
    }
}
