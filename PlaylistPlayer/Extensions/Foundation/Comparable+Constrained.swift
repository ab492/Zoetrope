//
//  Comparable.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 21/03/2021.
//

import Foundation

extension Comparable {
    func constrained(min: Self) -> Self {
        max(self, min)
    }

    func constrained(max: Self) -> Self {
        min(self, max)
    }
}

