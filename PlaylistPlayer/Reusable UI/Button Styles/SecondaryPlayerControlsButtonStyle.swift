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

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .frame(minWidth: 30, minHeight: 30)
            .foregroundColor((isSelected ? secondaryColor : primaryColor))
//            .foregroundColor((isSelected ? secondaryColor : primaryColor).opacity(configuration.isPressed ? 0.7: 1))
            .background(isSelected ? primaryColor : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .contentShape(Rectangle())
    }

//    private func foregroundColor(for configuration: Configuration) -> Color {
//        var color = isSelected ? secondaryColor : primaryColor
//        return color.overlay(Color.black
//                                .opacity(configuration.isPressed ? 0.3 : 0))
//    }




}
