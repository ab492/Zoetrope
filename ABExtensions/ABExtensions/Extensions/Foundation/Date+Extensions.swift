//
//  Date+Extensions.swift
//  ABExtensions
//
//  Created by Andy Brown on 03/07/2021.
//

import Foundation

public extension Date {

    init(day: Int, month: Int, year: Int) {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year

        let currentCalendar = Calendar.current
        self = currentCalendar.date(from: dateComponents)!
    }
}
