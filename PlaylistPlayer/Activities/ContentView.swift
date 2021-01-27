//
//  ContentView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

struct ContentView: View {

    // MARK: - State

    @State private var presentingPlayer = false
    @ObservedObject private var viewModel = PlaylistPlayerViewModel()

    // MARK: - View
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items.indices) { index in
                    Text(viewModel.items[index].lastPathComponent)
                        .onTapGesture {
                            viewModel.skipToItem(at: index)
                            presentingPlayer.toggle()
                        }
                }
            }
            .navigationTitle("Playlist Player")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $presentingPlayer) {
            CustomPlayerView(viewModel: viewModel)
        }
    }
}
