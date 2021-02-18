//
//  SecondaryPlayerControlsButtonStyle.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 16/02/2021.
//

import SwiftUI

struct SecondaryPlayerControlsButtonStyle: ButtonStyle {

    var isSelected = false
    var primaryColor = Color.accentColor
    var secondaryColor = Color.white

    private var foregroundColor: Color {
        isSelected ? secondaryColor : primaryColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
//            .overlay(Color.black)

            .frame(minWidth: 30, minHeight: 30)
//            .foregroundColor((configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor))
            .foregroundColor(foregroundColor1(configuration: configuration))
            .background(isSelected ? primaryColor : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .contentShape(Rectangle())
    }

    func foregroundColor1(configuration: Configuration) -> Color {
//        let color = Color.red.overlay(Color.black.opacity(0.3))
//        return color
        if configuration.isPressed {
            return (isSelected ? secondaryColor : primaryColor).opacity(0.3)
        } else {
            return (isSelected ? secondaryColor : primaryColor)
        }
    }
}
