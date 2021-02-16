//
//  LoopButton.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 15/02/2021.
//

import SwiftUI

struct LoopButton: View {

    @Binding var loopMode: LoopMode

    var isSelected: Bool {
        loopMode == .loopCurrent || loopMode == .loopPlaylist
    }

    var body: some View {
        Button {
            cycleLoopMode()
        } label: {
            selectImage()
        }
        .buttonStyle(SecondaryPlayerControlsButtonStyle(isSelected: isSelected))
    }

    private func cycleLoopMode() {
        switch loopMode {
        case .playPlaylistOnce:
            self.loopMode = .loopPlaylist
        case .loopCurrent:
            self.loopMode = .playPlaylistOnce
        case .loopPlaylist:
            self.loopMode = .loopCurrent
        }
    }

    private func selectImage() -> Image {
        switch loopMode {
        case .playPlaylistOnce:
            return Image(systemName: PlayerIcons.loopPlaylist)
        case .loopCurrent:
            return Image(systemName: PlayerIcons.loopCurrent)
        case .loopPlaylist:
            return Image(systemName: PlayerIcons.loopPlaylist)
        }
    }
}
