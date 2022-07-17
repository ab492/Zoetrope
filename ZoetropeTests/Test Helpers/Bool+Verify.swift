//
//  Bool+Verify.swift
//  Shoebox
//
//  Created by Andy Brown on 17/07/2021.
//

import Foundation
import XCTest

extension Bool {
    public func verifyTrue(file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(self, file: file, line: line)
    }

    public func verifyFalse(file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(self, file: file, line: line)
    }
}
