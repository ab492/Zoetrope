//
//  PlayerSettingsView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 28/04/2021.
//

import SwiftUI

struct ViewerSettingsView: View {

    // MARK: - State Properties

    @StateObject private var playerViewModel: PlaylistPlayerViewModel
    
    // MARK: - Init

    init(playerViewModel: PlaylistPlayerViewModel) {
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Playback Controls")) {
                    Toggle(isOn: $playerViewModel.useControlsTimer.animation()) {
                        Text("Use Controls Timer")
                    }
                    if playerViewModel.useControlsTimer {
                        Picker(selection: $playerViewModel.showControlsTime, label: Text("Timer")) {
                            ForEach(PlaylistPlayerViewModel.ShowControlsTime.allCases) { type in
                                Text(type.label)
                                    .accessibilityLabel("\(type.rawValue) seconds")
                                    .tag(type)
                            }
                        }
                    }
                }
                .listRowBackground(Color.tertiarySystemGroupedBackground)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.secondarySystemGroupedBackground)
        }
        .onAppear { UINavigationBar.appearance().backgroundColor = .secondarySystemGroupedBackground }
    }
}
