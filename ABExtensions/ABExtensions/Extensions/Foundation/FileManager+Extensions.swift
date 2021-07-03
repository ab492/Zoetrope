//
//  FileManager+Extensions.swift
//  ABExtensions
//
//  Created by Andy Brown on 03/07/2021.
//

import Foundation

public extension FileManager {
    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
