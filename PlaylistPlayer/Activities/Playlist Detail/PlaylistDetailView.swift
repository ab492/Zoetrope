//
//  PlaylistDetailView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import SwiftUI
import AVKit

struct PlaylistDetailView: View {

    @ObservedObject var playlistManager = Current.playlistManager
    @ObservedObject private var playlist: Playlist
    @StateObject private var viewModel = PlaylistPlayerViewModel()
    
    @State private var showingDocumentPicker = false
    @State private var urls: [URL]?
    @State private var presentingPlayer = false

    init(playlist: Playlist) {
        self.playlist = playlist

        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UIToolbar.appearance().barTintColor = .secondarySystemBackground
    }

    var body: some View {
        Group {
            if playlist.videos.isEmpty {
                EmptyContentView(text: "Add videos to get started")
            } else {
                videoList
            }
        }
        .toolbar {
            importMediaToolbarItem
            bottomToolbarItemCount
        }
        .navigationBarTitle(playlist.name, displayMode: .inline)
        fullScreenCover
        documentPicker
    }

    private var videoList: some View {
        List {
            ForEach(playlist.videos) { video in
                PlaylistDetailRow(video: video)
                    .onTapGesture {
                        if let index = playlist.videos.firstIndex(of: video) {
                            viewModel.skipToItem(at: index)
                        }
                        presentingPlayer.toggle()
                    }
            }
            .onDelete(perform: removeRows)
        }
        .onAppear { updateViewModel() }
    }

    private var fullScreenCover: some View {
        // .fullScreenCover and .sheet modifiers can't be applied to a single view, so we use an EmptyView() instead.
        EmptyView().hidden().fullScreenCover(isPresented: $presentingPlayer) {
            CustomPlayerView(viewModel: viewModel)
        }
    }

    private var documentPicker: some View {
        // .fullScreenCover and .sheet modifiers can't be applied to a single view, so we use an EmptyView() instead.
        EmptyView().hidden().sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker(urls: self.$urls.onChange(addMedia))
        }
    }

    // MARK: - Toolbar

    private var importMediaToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                self.showingDocumentPicker = true
            } label: {
                Label("Add Media", systemImage: "plus")
            }
        }
    }

    private var bottomToolbarItemCount: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Text(playlist.formattedCount)
        }
    }

    // MARK: - Helpers

    private func addMedia() {
        guard let urls = urls else { return }
        Current.playlistManager.addMediaAt(urls: urls, to: playlist)
        self.urls = nil
        updateViewModel()
    }

    private func removeRows(at offsets: IndexSet) {
        Current.playlistManager.deleteItems(fromPlaylist: playlist, at: offsets)
    }

    private func updateViewModel() {
        viewModel.updateQueue(for: playlist)
    }
}


//struct PlaylistDetailView: View {
//    // MARK: - State
//
//    @State private var videos: [Video]
//    @ObservedObject private var viewModel: PlaylistPlayerViewModel
//
//    init() {
//
//        let urls = ["01", "02", "03", "04", "05", "06", "07", "08"].compactMap { Bundle.main.url(forResource: $0, withExtension: "mov") }
//
//        var videos = [Video]()
//
//        for url in urls {
//            videos.append(Video(id: UUID(), url: url))
//        }
//
//        _videos = State(wrappedValue: videos)
//
//        let viewModel = PlaylistPlayerViewModel()
//        viewModel.replaceQueue(with: videos)
//        _viewModel = ObservedObject(wrappedValue: viewModel)
//    }
//
//    @State private var presentingPlayer = false
//
//    // MARK: - View
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(videos.indices) { index in
//                    Text(videos[index].filename)
//                        .onTapGesture {
//                            viewModel.skipToItem(at: index)
//                            presentingPlayer.toggle()
//                        }
//                }
//                .onMove(perform: moveRows)
//            }
//            .navigationBarItems(trailing: EditButton())
//            .navigationTitle("Playlist Player")
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .fullScreenCover(isPresented: $presentingPlayer) {
//            CustomPlayerView(viewModel: viewModel)
//        }
//    }
//
//    private func moveRows(from source: IndexSet, to destination: Int) {
//        videos.move(fromOffsets: source, toOffset: destination)
//        viewModel.replaceQueue(with: videos)
//    }
//}
