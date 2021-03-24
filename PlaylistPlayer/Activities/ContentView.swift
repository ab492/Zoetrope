//
//  ContentView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().backgroundColor = .clear
        UIApplication.shared.isStatusBarHidden = false // Temporary fix to hide the status bar since `.statusBar(hidden: _)` is unreliable.
    }

    var body: some View {
        NavigationView {
            
            // Primary view
            PlaylistSidebarView()
                .navigationTitle("Playlists")

            // Secondary view (when nothing selected from primary)
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                Text(secondaryText)
                    .italic()
                    .foregroundColor(.secondary)
            }

        }
    }
    
    private var secondaryText: String {
        Current.playlistManager.playlists.isEmpty ? "No playlists yet" : "Select a playlist"
    }
}
