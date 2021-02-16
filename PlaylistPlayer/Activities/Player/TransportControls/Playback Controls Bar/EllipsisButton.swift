//
//  EllipsisButton.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 16/02/2021.
//

import SwiftUI

struct EllipsisButton: View {
    @State var isSelected = false

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Image(systemName: PlayerIcons.showPlayerToolbar)
        }
        .buttonStyle(SecondaryPlayerControlsButtonStyle(isSelected: isSelected))
    }
}
