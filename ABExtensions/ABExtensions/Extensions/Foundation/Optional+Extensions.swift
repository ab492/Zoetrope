//
//  Optional+Extensions.swift
//  ABExtensions
//
//  Created by Andy Brown on 03/07/2021.
//

import Foundation

public extension Optional {
    var isNil: Bool {
        self == nil ? true : false
    }
}
