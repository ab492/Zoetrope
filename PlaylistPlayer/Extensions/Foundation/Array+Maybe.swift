//
//  Array+Maybe.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 16/02/2021.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (maybe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
