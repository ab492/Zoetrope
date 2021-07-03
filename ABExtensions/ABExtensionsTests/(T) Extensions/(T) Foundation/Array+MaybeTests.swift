//
//  Array+MaybeTests.swift
//  ABExtensionsTests
//
//  Created by Andy Brown on 03/07/2021.
//

import XCTest
@testable import ABExtensions

class ArrayMaybeTests: XCTestCase {

    func test_arrayMaybeReturnsValueIfExists() {
        let array = ["one", "two", "three", "four"]

        XCTAssertEqual(array[maybe: 2], "three")
    }

    func test_arrayMaybeReturnsNilIfDoesntExists() {
        let array = ["one", "two"]

        XCTAssertEqual(array[maybe: 2], nil)
    }

}
