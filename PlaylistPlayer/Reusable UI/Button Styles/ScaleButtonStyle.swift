//
//  ScaleButtonStyle.swift
//  Quickfire
//
//  Created by Andy Brown on 18/12/2020.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {

    private let width: CGFloat
    private let height: CGFloat

    init(width: CGFloat = 60, height: CGFloat = 60) {
        self.width = width
        self.height = height
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height, alignment: .center)
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}


