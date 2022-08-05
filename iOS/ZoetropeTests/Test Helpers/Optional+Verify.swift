//
//  Optional+Verify.swift
//  ZoetropeTests
//
//  Created by Andy Brown on 30/07/2022.
//

import Foundation
import XCTest

extension Optional {
    func verifyNil(file: StaticString = #file, line: UInt = #line) {
        XCTAssertNil(self, file: file, line: line)
    }
    
    func verifyNotNil(file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(self, file: file, line: line)
    }
}
