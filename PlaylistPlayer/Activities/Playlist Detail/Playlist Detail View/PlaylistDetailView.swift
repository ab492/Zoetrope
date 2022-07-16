//
//  PlaylistDetailView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import SwiftUI
import Combine

struct PlaylistDetailView: View {
    
    // MARK: - Types
    
    private enum SheetImportType: String, Identifiable {
        case files
        case cameraRoll
        
        var id: String { self.rawValue }
    }

    // MARK: - State
    
    @StateObject var viewModel: ViewModel
    @State private var importSheetType: SheetImportType?
    @State private var urls = [URL]()
    @State private var presentingPlayer = false

    // MARK: - Init

    init(playlist: Playlist) {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UIToolbar.appearance().barTintColor = .secondarySystemBackground
        _viewModel = StateObject(wrappedValue: ViewModel(playlist: playlist))
    }

    // MARK: - Main View

    var body: some View {
        ZStack {
            if viewModel.playlistIsEmpty {
                EmptyContentView(text: "Add videos to get started.")
            } else {
                videoList
            }
        }
        .toolbar {
            importMediaToolbarItem
            trailingToolbar
            bottomToolbarItemCount
        }
        .navigationBarTitle(viewModel.playlistTitle, displayMode: .inline)
        .fullScreenCover(isPresented: $presentingPlayer) {
            CustomPlayerView(playlistPlayer: Current.playlistPlayer)
        }
    }

    private var videoList: some View {
        List() {
            ForEach(viewModel.videos) { video in
                PlaylistDetailRow(video: video)
                    .onTapGesture {
                        updateViewModel()
                        Current.playlistPlayer.skipToItem(at: viewModel.index(of: video))
                        presentingPlayer.toggle()
                    }
            }
            .onDelete(perform: removeRows)
            .onMove(perform: moveRows)
        }.listStyle(.plain)
    }
    
    // MARK: - Toolbar

    private var trailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if viewModel.shouldShowSortMenu { sortMenu }
            if viewModel.shouldShowEditMenu { EditButton() }
        }
    }
    
    private var sortMenu: some View {
        Menu {
            Button {
                viewModel.sortByTitleSortOrder.toggle()
            } label: {
                let icon = viewModel.sortByTitleSortOrder == .ascending ? "chevron.down" : "chevron.up"
                MenuItemView(title: "Sort by Title", iconSystemName: icon)
            }
            Button {
                viewModel.sortByDurationSortOrder.toggle()
            } label: {
                let icon = viewModel.sortByDurationSortOrder == .ascending ? "chevron.down" : "chevron.up"
                MenuItemView(title: "Sort by Duration", iconSystemName: icon)
            }

        } label: {
            Label("Sort Playlist", systemImage: "arrow.up.arrow.down")
                .frame(width: 50)
        }
    }
    
    private var importMediaToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Menu {
                Button("Import from Files", action: { self.importSheetType = .files })
                Button("Import from Camera Roll", action: { self.importSheetType = .cameraRoll })
            } label: {
                Label("Add Media", systemImage: "plus")
            }
            .sheet(item: $importSheetType) { sheetType in
                switch sheetType {
                case .cameraRoll:
                    CameraRollVideoPicker(movieURLs: self.$urls.onChange(addMedia))
                case .files:
                    DocumentPicker(urls: self.$urls.onChange(addMedia))
                }
            }
        }
    }
    
    private var bottomToolbarItemCount: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Text(viewModel.playlistCount)
        }
    }

    // MARK: - Helpers

    private func addMedia() {
        viewModel.addMedia(at: urls)
        self.urls = []
    }

    private func moveRows(from source: IndexSet, to destination: Int) {
        viewModel.moveVideo(from: source, to: destination)
    }

    private func removeRows(at offsets: IndexSet) {
        viewModel.removeRows(at: offsets)
    }

    private func updateViewModel() {
        Current.playlistPlayer.updateQueue(for: viewModel.playlist)
    }
}
