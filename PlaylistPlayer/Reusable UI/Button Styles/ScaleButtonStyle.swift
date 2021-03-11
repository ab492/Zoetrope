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
    private let enabledColor: Color
    private let disabledColor: Color

    init(width: CGFloat = 60, height: CGFloat = 60, enabledColor: Color = .white, disabledColor: Color = .secondary) {
        self.width = width
        self.height = height
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
    }

    func makeBody(configuration: Configuration) -> some View {
        ScaleButton(configuration: configuration, width: width, height: height, enabledColor: enabledColor, disabledColor: disabledColor)
    }

    private struct ScaleButton: View {
        @Environment(\.isEnabled) private var isEnabled: Bool
        let configuration: ButtonStyle.Configuration
        let width: CGFloat
        let height: CGFloat
        let enabledColor: Color
        let disabledColor: Color

        var body: some View {
            configuration.label
                .frame(width: width, height: height, alignment: .center)
                .contentShape(Rectangle())
                .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
                .foregroundColor(isEnabled ? enabledColor : disabledColor)
        }
    }
}
