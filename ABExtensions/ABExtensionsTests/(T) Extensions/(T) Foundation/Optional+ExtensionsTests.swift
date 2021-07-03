//
//  Optional+ExtensionsTests.swift
//  ABExtensionsTests
//
//  Created by Andy Brown on 03/07/2021.
//

import XCTest

final class OptionalExtensionTests: XCTestCase {

    func test_isNil_withNilValue()  {
        let optionalString: String? = nil

        XCTAssertEqual(optionalString.isNil, true)
    }

    func test_isNil_withNonNilValue()  {
        let optionalString: String? = "Test String"

        XCTAssertEqual(optionalString.isNil, false)
    }
}
