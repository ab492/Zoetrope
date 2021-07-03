//
//  Color+Extensions.swift
//  ABExtensions
//
//  Created by Andy Brown on 03/07/2021.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
