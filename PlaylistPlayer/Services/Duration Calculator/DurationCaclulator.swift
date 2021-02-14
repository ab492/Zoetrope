//
//  DurationCaclulator.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 13/02/2021.
//

import AVFoundation

protocol DurationCalculator {
    func durationForAsset(at url: URL) -> Time
}

class DurationCalculatorImpl: DurationCalculator {
    func durationForAsset(at url: URL) -> Time {
        return Time(seconds: AVAsset(url: url).duration.seconds)
    }
}
