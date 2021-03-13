//
//  Date.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 12/03/2021.
//

import Foundation
import QuartzCore

protocol DateTimeService {
    var date: Date { get }
    var absoluteTime: Double { get }
}

class DateTimeServiceImpl: DateTimeService {

    var date: Date {
        Date()
    }

    var absoluteTime: Double {
        CACurrentMediaTime()
    }
}
