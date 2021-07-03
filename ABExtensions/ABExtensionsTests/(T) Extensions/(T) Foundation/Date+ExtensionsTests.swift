//
//  Date+ExtensionsTests.swift
//  ABExtensionsTests
//
//  Created by Andy Brown on 03/07/2021.
//

import XCTest

final class DateExtensionTests: XCTestCase {

    func test_dateCanBeInitFromDayMonthYear()  {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"

        let date = Date(day: 14, month: 03, year: 1992)

        XCTAssertEqual(formatter.string(from: date), "14/03/1992")
    }
}
