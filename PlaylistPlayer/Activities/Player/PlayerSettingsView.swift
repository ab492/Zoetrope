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

struct PlayerSettingsView: View {

    let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]

    // MARK: - State Properties

    @StateObject var playerViewModel: PlaylistPlayerViewModel
//    @State private var color: String = "Red"

    // MARK: - Init

    init(playerViewModel: PlaylistPlayerViewModel) {
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
    }

    // MARK: - View

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

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
