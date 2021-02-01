//
//  PlaybackControlsButton.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 24/01/2021.
//

import SwiftUI

struct PlaybackControlsButton: View {
    let systemImage: String
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: systemImage)
                .font(.largeTitle)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
