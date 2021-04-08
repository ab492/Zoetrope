//
//  PlaylistDetailView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import SwiftUI
import Combine

struct PlaylistDetailView: View {

    // FIXME: For multi selection deletion
    //https://stackoverflow.com/questions/57784859/swiftui-how-to-perform-action-when-editmode-changes

    // MARK: - State
    @StateObject var playlistDetailViewModel: ViewModel
    @State private var playlistPlayer = PlaylistPlayerImpl()
    @State var editMode: EditMode = .inactive
    @State private var showingDocumentPicker = false
    @State private var urls: [URL]?
    @State private var presentingPlayer = false

    // MARK: - Init

    init(playlist: Playlist) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UIToolbar.appearance().barTintColor = .secondarySystemBackground
        _playlistDetailViewModel = StateObject(wrappedValue: ViewModel(playlist: playlist))
    }

    // MARK: - Main View

    var body: some View {
        ZStack {
            if playlistDetailViewModel.playlistIsEmpty {
                EmptyContentView(text: "Add videos to get started")
            } else {
                videoList
            }
        }
        .animation(.default)
        .toolbar {
            importMediaToolbarItem
            trailingToolbar
            bottomToolbarItemCount
        }
        .navigationBarTitle(playlistDetailViewModel.playlistTitle, displayMode: .inline)
        .environment(\.editMode, self.$editMode)
        .fullScreenCover(isPresented: $presentingPlayer) {
            CustomPlayerView(playlistPlayer: playlistPlayer)
        }
    }

    private var videoList: some View {
        List() {
            ForEach(playlistDetailViewModel.videos) { video in
                PlaylistDetailRow(video: video)
                    .onTapGesture {
                        updateViewModel()
                        playlistPlayer.skipToItem(at: playlistDetailViewModel.index(of: video))
                        presentingPlayer.toggle()
                    }
            }
            .onDelete(perform: removeRows)
            .onMove(perform: moveRows)
        }
    }
    
    // MARK: - Toolbar

    private var trailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            sortMenu
            editButton
        }
    }

    private var editButton: some View {
        Button(action: {
            self.editMode.toggle()
            }) {
                Text(self.editMode == .active ? "Done" : "Edit")
        }
    }

    private var sortMenu: some View {
        Menu {
            Button {
                playlistDetailViewModel.sortByTitleSortOrder.toggle()
            } label: {
                let icon = playlistDetailViewModel.sortByTitleSortOrder == .ascending ? "chevron.down" : "chevron.up"
                MenuItemView(title: "Sort by Title", iconSystemName: icon)
            }
            Button {
                playlistDetailViewModel.sortByDurationSortOrder.toggle()
            } label: {
                let icon = playlistDetailViewModel.sortByDurationSortOrder == .ascending ? "chevron.down" : "chevron.up"
                MenuItemView(title: "Sort by Duration", iconSystemName: icon)
            }

        } label: {
            Label("Sort Playlist", systemImage: "arrow.up.arrow.down")
                .frame(width: 50)
        }
    }
    
    private var importMediaToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                self.showingDocumentPicker = true
            } label: {
                Label("Add Media", systemImage: "plus")
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(urls: self.$urls.onChange(addMedia))
            }
        }
    }

    private var bottomToolbarItemCount: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Text(playlistDetailViewModel.playlistCount)
        }
    }

    // MARK: - Helpers

    private func addMedia() {
        guard let urls = urls else { return }
        playlistDetailViewModel.addMedia(at: urls)
        self.urls = nil
    }

    private func moveRows(from source: IndexSet, to destination: Int) {
        playlistDetailViewModel.moveVideo(from: source, to: destination)
    }

    private func removeRows(at offsets: IndexSet) {
        playlistDetailViewModel.removeRows(at: offsets)
    }

    private func updateViewModel() {
        playlistPlayer.updateQueue(for: playlistDetailViewModel.playlist)
    }
}
