//
//  ScaleButtonStyle.swift
//  Quickfire
//
//  Created by Andy Brown on 18/12/2020.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        ScaleButton(configuration: configuration)
    }

    private struct ScaleButton: View {
        let configuration: ButtonStyle.Configuration
        
        var body: some View {
            configuration.label
                //https://stackoverflow.com/questions/59169436/swiftui-buttonstyle-how-to-check-if-button-is-disabled-or-enabled
                .frame(width: 60, height: 60, alignment: .center)
                .contentShape(Rectangle())
                .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}
