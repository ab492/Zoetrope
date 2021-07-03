//
//  Array+Maybe.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 16/02/2021.
//

import Foundation

public extension Collection {
    subscript (maybe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
