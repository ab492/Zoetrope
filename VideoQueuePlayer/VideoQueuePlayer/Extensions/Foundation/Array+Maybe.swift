//
//  Array+Maybe.swift
//  VideoQueuePlayer
//
//  Created by Andy Brown on 03/07/2021.
//

import Foundation

extension Collection {
    subscript (maybe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
