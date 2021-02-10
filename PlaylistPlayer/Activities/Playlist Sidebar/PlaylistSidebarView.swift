//
//  PlaylistSidebarView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import SwiftUI

struct PlaylistSidebarView: View {

    @EnvironmentObject var dataController: DataController

    init() {
//        UITableView.appearance().backgroundColor = .secondarySystemGroupedBackground
//        UINavigationBar.appearance().backgroundColor = .systemRed
    }

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.secondarySystemGroupedBackground.edgesIgnoringSafeArea(.all)
            if dataController.playlists.isEmpty {
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
            ForEach(dataController.playlists) { playlist in
                NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                    HStack {
                        Text(playlist.name)
                        Spacer()
//                        Text(playlist.formattedCount)
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
            if dataController.playlists.count > 0 {
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
            dataController.addPlaylist(Playlist(name: "My Test Playlist"))
        }
    }
    
    private func moveRows(from source: IndexSet, to destination: Int) {
        dataController.movePlaylist(from: source, to: destination)
    }

    private func removeRows(at offsets: IndexSet) {
        dataController.delete(playlistsAt: offsets)
    }

    var formattedPlaylistCount: String {
        switch dataController.playlists.count {
        case 1:
            return "1 playlist"
        default:
            return "\(dataController.playlists.count) playlists"
        }
    }
}
