//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import PencilKit

struct CustomPlayerView: View {

    // MARK: - State

    @StateObject private var viewModel: PlaylistPlayerViewModel
    @State private var localShowTransportControls = true
    @State private var localShowSettings = false
    
    // MARK: - Init

    init(playlistPlayer: PlaylistPlayer) {
        let playlistPlayerViewModel = StateObject(wrappedValue: PlaylistPlayerViewModel(playlistPlayer: playlistPlayer))
        _viewModel = playlistPlayerViewModel
    }

    // MARK: - View

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                ZStack {
                    videoPlaybackView.zIndex(0)
                }.zIndex(0)

                if localShowTransportControls {
                    transportControls.zIndex(1)
                }
            }
            .ignoresSafeArea(edges: .top)
            Group {
                if localShowSettings {
                    settingsPanel
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .onChange(of: viewModel.showTransportControls, perform: { showTransportControls in
            // Using a local @State to mirror the view model, allowing us to easily add animation and update status bar.
            // https://stackoverflow.com/questions/67220033/swiftui-animation-from-published-property-changing-from-outside-the-view
            withAnimation(.easeIn(duration: 0.1)) {
                localShowTransportControls = showTransportControls
                // Temporary fix to hide the status bar since `.statusBar(hidden: _)` is unreliable.
                UIApplication.shared.isStatusBarHidden = !showTransportControls
            }
        })
        .onChange(of: localShowSettings, perform: { showSettings in
            viewModel.didTapSettings(show: showSettings)
        })
        .onAppear { viewModel.play() }
        .onDisappear { viewModel.pause() }
    }

    private var videoPlaybackView: some View {
        CustomPlayerLayer(viewModel: viewModel)
            .onTapGesture {
                viewModel.didTapVideo()
            }
    }
    
    private var transportControls: some View {
        TransportControls(playerOptionsIsSelected: $localShowSettings.animation(), viewModel: viewModel)
    }

    private var settingsPanel: some View {
        SettingsScreen(playerViewModel: viewModel)
            .cornerRadius(10)
            .padding([.leading, .trailing], 4)
            .frame(width: 350)
    }
}
