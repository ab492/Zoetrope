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
                VStack(alignment: .center, spacing: 10) {
                    Text(secondaryTextTitle)
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    Text(secondaryTextSubtitle)
                        .foregroundColor(.secondary)
                        .font(.body)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom) // Prevents the view moving up when the keyboard appears.
            .navigationBarTitle("") // Required to hide the navigation bar to allow the text to be centred.
            .navigationBarHidden(true)
        }
    }
    
    private var secondaryTextTitle: String {
        Current.playlistManager.playlists.isEmpty ? "No Playlists" : "No Playlist Selected"
    }

    private var secondaryTextSubtitle: String {
        Current.playlistManager.playlists.isEmpty ? "Please add a playlist to get started." : "Please select a playlist to show details."
    }
}
