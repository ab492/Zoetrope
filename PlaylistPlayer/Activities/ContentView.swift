//
//  ContentView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - State

    @State private var videos: [Video]
    @ObservedObject private var viewModel: PlaylistPlayerViewModel

    init() {

        let urls = ["01", "02", "03", "04", "05", "06", "07", "08"].compactMap { Bundle.main.url(forResource: $0, withExtension: "mov") }

        var videos = [Video]()

        for url in urls {
            videos.append(Video(id: UUID(), url: url))
        }

        _videos = State(wrappedValue: videos)

        let viewModel = PlaylistPlayerViewModel()
        viewModel.replaceQueue(with: videos)
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    @State private var presentingPlayer = false

    // MARK: - View
    
    var body: some View {
        NavigationView {
            List {
                ForEach(videos.indices) { index in
                    Text(videos[index].filename)
                        .onTapGesture {
                            viewModel.skipToItem(at: index)
                            presentingPlayer.toggle()
                        }
                }
                .onMove(perform: moveRows)
            }
            .navigationBarItems(trailing: EditButton())
            .navigationTitle("Playlist Player")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $presentingPlayer) {
            CustomPlayerView(viewModel: viewModel)
        }
    }

    private func moveRows(from source: IndexSet, to destination: Int) {
        videos.move(fromOffsets: source, toOffset: destination)
        viewModel.replaceQueue(with: videos)
    }

}
