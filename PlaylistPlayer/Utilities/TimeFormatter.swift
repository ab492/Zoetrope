//
//  TimeFormatter.swift
//  Quickfire
//
//  Created by Andy Brown on 17/12/2020.
//

import Foundation

struct TimeFormatter {
    /// Formats seconds into the format 00:00:00. Only displays the first set of leading zeros.
    static func string(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60

        if hours < 1 {
            return String(format: "%02i:%02i", minutes, seconds)
        } else {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
}
