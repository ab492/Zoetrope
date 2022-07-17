//
//  PlaylistSidebarView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import SwiftUI

struct PlaylistSidebarView: View {

    // MARK: - State and Init
    
    @StateObject private var viewModel = ViewModel()
    @State private var isShowingSettings = false
    @State private var isShowingAddPlaylistModal = false

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }

    // MARK: - View

    var body: some View {
        ZStack {
            Color.secondarySystemGroupedBackground.edgesIgnoringSafeArea(.all)
            if viewModel.playlistStoreIsEmpty {
                EmptyContentView(text: "Add a playlist to get started")
            } else {
                playlistList
            }
        }
        .toolbar {
            editListNavigationItem
            bottomToolbar
        }
    }

    private var playlistList: some View {
        List {
            ForEach(viewModel.playlists) { playlist in
                NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                    Text(playlist.name)
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
            if viewModel.playlistStoreIsEmpty == false {
                EditButton()
            }
        }
    }

    private var bottomToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                isShowingSettings.toggle()
            } label: {
                Label("Settings", systemImage: "gearshape")
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
                    // https://stackoverflow.com/questions/60313431/swiftui-how-to-close-the-sheet-view-while-dismissing-that-view
                    .environment(\.showingSheet, self.$isShowingSettings)
            }

            Spacer()
            Text(viewModel.playlistCount)
            Spacer()
            Button {
                isShowingAddPlaylistModal.toggle()
            } label: {
                Label("Add Playlist", systemImage: "folder.badge.plus")
            }
            .sheet(isPresented: $isShowingAddPlaylistModal) {
                AddPlaylistModal { playlistTitle in
                    self.addPlaylist(title: playlistTitle)
                }
            }
        }
    }

    // MARK: - Helpers

    private func addPlaylist(title: String) {
        withAnimation {
            viewModel.addPlaylist(title)
        }
    }

    private func moveRows(from source: IndexSet, to destination: Int) {
        viewModel.movePlaylist(from: source, to: destination)
    }

    private func removeRows(at offsets: IndexSet) {
        viewModel.removePlaylists(at: offsets)
    }
}
