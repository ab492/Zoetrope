//
//  PlaylistDetailView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/02/2021.
//

import SwiftUI
import Combine

struct PlaylistDetailView: View {

    // MARK: - State

    @StateObject private var playlistPlayerViewModel = PlaylistPlayerViewModel()
    @StateObject var playlistDetailViewModel: ViewModel

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

    // MARK: - Views

    var body: some View {
        ZStack {
            if playlistDetailViewModel.playlistIsEmpty {
                EmptyContentView(text: "Add videos to get started")
            } else {
                videoList
            }
        }
        .toolbar {
            importMediaToolbarItem
            bottomToolbarItemCount
        }
        .navigationBarTitle(playlistDetailViewModel.playlist.name, displayMode: .inline)
        fullScreenCover
        documentPicker
    }
    
    private var videoList: some View {
        List {
            ForEach(playlistDetailViewModel.playlist.videos) { video in
                PlaylistDetailRow(video: video)
                    .onTapGesture {
                        updateViewModel()
                        playlistPlayerViewModel.skipToItem(at: playlistDetailViewModel.index(of: video))
                        presentingPlayer.toggle()
                    }
            }
            .onDelete(perform: removeRows)
        }
    }

    private var fullScreenCover: some View {
        // .fullScreenCover and .sheet modifiers can't be applied to a single view, so we use an EmptyView() instead.
        EmptyView().hidden().fullScreenCover(isPresented: $presentingPlayer) {
            CustomPlayerView(viewModel: playlistPlayerViewModel)
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
            Text(playlistDetailViewModel.playlist.formattedCount)
        }
    }

    // MARK: - Helpers

    private func addMedia() {
        guard let urls = urls else { return }
        playlistDetailViewModel.addMedia(at: urls)
        self.urls = nil
        updateViewModel()
    }

    private func removeRows(at offsets: IndexSet) {
        playlistDetailViewModel.removeRows(at: offsets)
    }

    private func updateViewModel() {
        playlistPlayerViewModel.updateQueue(for: playlistDetailViewModel.playlist)
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
