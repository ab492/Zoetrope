//
//  ScaleButtonStyle.swift
//  Quickfire
//
//  Created by Andy Brown on 18/12/2020.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 60, alignment: .center)
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}


