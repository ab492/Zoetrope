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
            .ignoresSafeArea(.keyboard, edges: .bottom) // Prevents the text moving up when the keyboard is presented.
        }
    }
    
    private var secondaryText: String {
        Current.playlistManager.playlists.isEmpty ? "No playlists yet" : "Select a playlist"
    }
}
