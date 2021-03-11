//
//  EditMode+Toggle.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/03/2021.
//

import SwiftUI

extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
