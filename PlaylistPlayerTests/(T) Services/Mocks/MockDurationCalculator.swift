//
//  MockDurationCalculator.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 14/02/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockDurationCalculator: DurationCalculator {

    var durationToReturn: Time = Time(seconds: 0)
    func durationForAsset(at url: URL) -> Time {
        return durationToReturn
    }

}
