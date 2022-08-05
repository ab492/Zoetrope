//
//  Equatable+Verify.swift
//  Shoebox
//
//  Created by Andy Brown on 17/07/2021.
//

import Foundation
import XCTest

extension Equatable {
    public func verify(equals other: Self, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self, other, file: file, line: line)
    }
}
