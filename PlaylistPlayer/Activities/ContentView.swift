//
//  ContentView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
    }

    var body: some View {
        NavigationView {
            
            // Primary view
            PlaylistSidebarView()
                .navigationTitle("Playlists")

            // Secondary view (when nothing selected from primary)
            Text(secondaryText)
                .italic()
                .foregroundColor(.secondary)
        }
    }
    
    private var secondaryText: String {
        Current.playlistManager.playlists.isEmpty ? "No playlists yet" : "Select a playlist"
    }
}
