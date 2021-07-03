//
//  Time.swift
//  QFS
//
//  Created by Andy Brown on 09/06/2020.
//  Copyright © 2020 Andy Brown. All rights reserved.
//

import Foundation

public struct Time: Equatable {

    private let timeInSeconds: Double

    public init(seconds: Double) {
        self.timeInSeconds = seconds

    }

    public var seconds: Double {
        return timeInSeconds
    }
}

// MARK: - Comparable

extension Time: Comparable {
    public static func < (lhs: Time, rhs: Time) -> Bool {
        lhs.seconds < rhs.seconds
    }
}

// MARK: - Codable

extension Time: Codable { }

// MARK: - Static Constants

extension Time {
    static let zero = Time(seconds: 0)
}
