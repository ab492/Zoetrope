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
        print("INIT?!")
        self.playlist = playlist
//        let viewModel = PlaylistPlayerViewModel()
//        viewModel.updateQueue(for: playlist)
//        _viewModel = StateObject(wrappedValue: viewModel)
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
        }
        .navigationTitle(playlist.name)
        fullScreenCover
        documentPicker
    }

    private var videoList: some View {
        List {
            ForEach(playlist.videos) { video in
                Text(video.filename)
                    .onTapGesture {
                        if let index = playlist.videos.firstIndex(of: video) {
                            viewModel.skipToItem(at: index)
                        }
                        presentingPlayer.toggle()
                    }
            }
        }
        .onAppear { updateViewModel() }
    }

    private var fullScreenCover: some View {
        // Fixes a known bug where .fullScreenCover and .sheet modifiers can't be applied to a single view.
        Text("").hidden().fullScreenCover(isPresented: $presentingPlayer) {
            CustomPlayerView(viewModel: viewModel)
        }
    }

    private var documentPicker: some View {
        // Fixes a known bug where .fullScreenCover and .sheet modifiers can't be applied to a single view.
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

    // MARK: - Helpers

    private func addMedia() {
        print("Add media?!")
        guard let urls = urls else { return }
        Current.playlistManager.addMediaAt(urls: urls, to: playlist)
        self.urls = nil
        updateViewModel()
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
