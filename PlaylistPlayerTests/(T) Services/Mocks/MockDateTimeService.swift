//
//  MockDateTimeService.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 12/03/2021.
//

import Foundation
@testable import PlaylistPlayer

final class MockDateTimeService: DateTimeService {
    init() {
        print("SET UP?!")
    }
    var date = Date(day: 14, month: 3, year: 1992)

    var absoluteTime: Double = .zero
}
