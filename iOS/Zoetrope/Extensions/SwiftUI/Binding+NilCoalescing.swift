//
//  Binding+NilCoalescing.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 30/03/2021.
//

import SwiftUI

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
