//
//  Time.swift
//  QFS
//
//  Created by Andy Brown on 09/06/2020.
//  Copyright © 2020 Andy Brown. All rights reserved.
//

import Foundation

struct Time: Equatable {

    private let timeInSeconds: Double

    init(seconds: Double) {
        self.timeInSeconds = seconds
    }
    
    init(minutes: Double) {
        self.init(seconds: minutes * 60)
    }
    
    init(mediaTime: MediaTime) {
        self.init(seconds: mediaTime.seconds)
    }

    var seconds: Double {
        return timeInSeconds
    }
}

// MARK: - Comparable

extension Time: Comparable {
    static func < (lhs: Time, rhs: Time) -> Bool {
        lhs.seconds < rhs.seconds
    }
}

// MARK: - Codable

extension Time: Codable { }

// MARK: - Static Constants

extension Time {
    static let zero = Time(seconds: 0)
}
