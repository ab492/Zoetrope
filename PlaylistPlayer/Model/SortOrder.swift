//
//  SortOrder.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 19/03/2021.
//

import Foundation

enum SortOrder: Int {
    case ascending
    case descending

    mutating func toggle() {
        self = self == .ascending ? .descending : .ascending
    }
}
