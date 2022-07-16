//
//  Optional+Extensions.swift
//  Shoebox
//
//  Created by Andy Brown on 04/08/2021.
//

import Foundation
import XCTest

extension Optional {

    enum OptionalError: Error {
        case optionalIsNil
    }

    func assertUnwrap(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        switch self {
        case .none:
            XCTFail("Optional was nil", file: file, line: line)
            throw OptionalError.optionalIsNil
        case .some(let value):
            return value
        }
    }
}
