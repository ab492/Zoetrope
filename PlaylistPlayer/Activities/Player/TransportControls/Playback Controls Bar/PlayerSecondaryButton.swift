//
//  EllipsisButton.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 16/02/2021.
//

import SwiftUI

struct PlayerSecondaryButton: View {
    var systemImage: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Image(systemName: systemImage)
        }
        .buttonStyle(SecondaryPlayerControlsButtonStyle(isSelected: isSelected))
    }
}
