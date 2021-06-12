//
//  PlayerSettingsView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 28/04/2021.
//

import SwiftUI

enum NoteOverlayPosition: String, CaseIterable {
    case top = "Top"
    case bottom = "Bottom"
}

struct ViewerOptionsScreen: View {

    // MARK: - State Properties

    @StateObject var playerViewModel: PlaylistPlayerViewModel

    // MARK: - Init

    init(playerViewModel: PlaylistPlayerViewModel) {
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display Bookmarks")) {
                    Toggle(isOn: $playerViewModel.overlayNotes.animation()) {
                        Text("Overlay Notes")
                    }
                    if playerViewModel.overlayNotes {
                        ColorPicker("Note Color", selection: $playerViewModel.noteColor)
                    }
                }
                .listRowBackground(Color.tertiarySystemGroupedBackground)
            }
            .navigationTitle("Viewer Options")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.secondarySystemGroupedBackground)
        }
        .onAppear { UINavigationBar.appearance().backgroundColor = .secondarySystemGroupedBackground }
    }
}
