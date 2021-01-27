//
//  TimeControlsBar.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 24/01/2021.
//

import SwiftUI

struct TimeControlsBar: View {

    @Binding var loopMode: PlaylistPlayer.LoopMode

    @State var value: CGFloat = 75

    var body: some View {


        VStack {
            loopButton
            CustomSlider(value: $value,
                         in: 0...100,
                         configuration: CustomSlider.Configuration(onDragStart: { print("Started!") }, onDragFinish: { print("Finished!") }))
                .frame(height: 50)
        }
    }

    // FIXME: Fix accessibility for this label.
    @ViewBuilder
    private var loopButton: some View {
        switch loopMode {
        case .loopCurrent:
            PlaybackControlsButton(systemImage: Icons.loopCurrent, onTap: { loopMode = .playPlaylistOnce })
                .foregroundColor(.white)
                .accessibility(label: Text("Play playlist once"))
        case .loopPlaylist:
            PlaybackControlsButton(systemImage: Icons.loopPlaylist, onTap: { loopMode = .loopCurrent })
                .foregroundColor(.white)
                .accessibility(label: Text("Repeat current"))
        case .playPlaylistOnce:
            PlaybackControlsButton(systemImage: Icons.loopPlaylist, onTap: { loopMode = .loopPlaylist })
                .foregroundColor(.gray)
                .accessibility(label: Text("Repeat playlist"))
        }
    }

    private var accessibilityValue: String {
        switch loopMode {

        case .loopCurrent:
            return "Loop current"
        case .loopPlaylist:
            return "Loop playlist"
        case .playPlaylistOnce:
            return "Play playlist once"
        }
    }
//    .accessibilityAddTraits(
//        item == color
//            ? [.isButton, .isSelected]
//            : .isButton
//    )

    private struct Icons {
        static let loopPlaylist = "repeat"
        static let loopCurrent = "repeat.1"
    }
}
