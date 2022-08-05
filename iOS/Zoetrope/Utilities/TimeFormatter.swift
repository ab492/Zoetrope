//
//  TimeFormatter.swift
//  Quickfire
//
//  Created by Andy Brown on 17/12/2020.
//

import Foundation

extension Double {
    func orZeroIfNan() -> Double {
        self.isNaN ? 0 : self
    }
    
    func orZeroIfInfinite() -> Double {
        self.isInfinite ? 0 : self
    }
}

struct TimeFormatter {
    
    // MARK: - Types

    private struct Duration {
        let hours: Int
        let minutes: Int
        let seconds: Int
        
        init(time: Time) {
            var seconds = time.seconds.orZeroIfNan().orZeroIfInfinite()
            
            let hours = seconds / (60 * 60)
            seconds = seconds.truncatingRemainder(dividingBy: (60 * 60))
            
            let minutes = seconds / 60
            seconds = seconds.truncatingRemainder(dividingBy: 60)
            
            self.hours = Int(hours)
            self.minutes = Int(minutes)
            self.seconds = Int(seconds)
        }
    }
    
    // MARK: - Properties
    
    private let accessiblityDateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .full
        return formatter
    }()

    // MARK: - Public
    
    /// Formats seconds into the format 00:00:00. Only displays the first set of leading zeros (e.g. 23:09, 01:12:34).
    func string(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60

        if hours < 1 {
            return String(format: "%02i:%02i", minutes, seconds)
        } else {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
    /**
     ## Examples:
     - '0 minutes, 10 seconds'
     - '30 minutes, 50 seconds'
     - '1 hour, 10 minutes, 50 seconds'
     */
    func accessibilityString(from time: Time) -> String {
        let duration = Duration(time: time)
        
        if duration.hours > 0 {
            accessiblityDateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
        } else {
            accessiblityDateComponentsFormatter.allowedUnits = [.minute, .second]
        }
        
        var components = DateComponents()
        components.hour = duration.hours
        components.minute = duration.minutes
        components.second = duration.seconds
        
        return accessiblityDateComponentsFormatter.string(from: components) ?? ""
    }
}
