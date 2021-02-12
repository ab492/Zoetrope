//
//  PlaylistSidebarView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import SwiftUI

struct PlaylistSidebarView: View {

    @ObservedObject var playlistManager = Current.playlistManager
    
    init() {
//        UITableView.appearance().backgroundColor = .secondarySystemGroupedBackground
//        UINavigationBar.appearance().backgroundColor = .systemRed
    }

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.secondarySystemGroupedBackground.edgesIgnoringSafeArea(.all)
            if playlistManager.playlists.isEmpty {
                EmptyContentView(text: "Add a playlist to get started")
            } else {
                playlistList
            }

        }
        .toolbar {
            editListNavigationItem
            bottomToolbarPlaylistCount
            bottomToolbarSpacer
            bottomToolbarAddPlaylist
        }
    }

    private var playlistList: some View {
        List {
            ForEach(playlistManager.playlists) { playlist in
                NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                    HStack {
                        Text(playlist.name)
                        Spacer()
                        Text(playlist.formattedCount)
                    }
                }
            }
            .onMove(perform: moveRows)
            .onDelete(perform: removeRows)
        }
        .listStyle(SidebarListStyle())
    }

    // MARK: - Toolbar

    private var editListNavigationItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if playlistManager.playlists.count > 0 {
                EditButton()
            }
        }
    }

    private var bottomToolbarAddPlaylist: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Button(action: addPlaylist) {
                Label("Add Playlist", systemImage: "folder.badge.plus")
            }
        }
    }

    private var bottomToolbarPlaylistCount: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Text(formattedPlaylistCount)
        }
    }

    // Due to a SwiftUI bug, the bottom toolbar requires an empty spacer to layout multiple correctly.
    private var bottomToolbarSpacer: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Spacer()
        }
    }

    // MARK: - Helpers

    private func addPlaylist() {
        withAnimation {
            playlistManager.addPlaylist(Playlist(name: "My Test Playlist"))
        }
    }
    
    private func moveRows(from source: IndexSet, to destination: Int) {
        playlistManager.movePlaylist(from: source, to: destination)
    }

    private func removeRows(at offsets: IndexSet) {
        playlistManager.delete(playlistsAt: offsets)
    }

    var formattedPlaylistCount: String {
        switch playlistManager.playlists.count {
        case 1:
            return "1 playlist"
        default:
            return "\(playlistManager.playlists.count) playlists"
        }
    }
}
