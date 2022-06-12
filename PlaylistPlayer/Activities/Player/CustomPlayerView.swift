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

    @StateObject private var playlistPlayerViewModel: PlaylistPlayerViewModel
    @State private var showSettings = false
    @State private var showTransportControls = true
    
    // MARK: - Init

    init(playlistPlayer: PlaylistPlayer) {
        let playlistPlayerViewModel = StateObject(wrappedValue: PlaylistPlayerViewModel(playlistPlayer: playlistPlayer))
        _playlistPlayerViewModel = playlistPlayerViewModel
    }

    // MARK: - View

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                ZStack {
                    videoPlaybackView.zIndex(0)
                }.zIndex(0)

                if showTransportControls {
                    transportControls.zIndex(1)
                }
            }
            .ignoresSafeArea(edges: .top)
            Group {
                if showSettings {
                    settingsPanel
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .onAppear { playlistPlayerViewModel.play() }
        .onDisappear { playlistPlayerViewModel.pause() }
    }

    private var videoPlaybackView: some View {
        CustomPlayerLayer(viewModel: playlistPlayerViewModel)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.1)) {
                    showTransportControls.toggle()
                    //                    visibleControlsConfigurator.isShowingTransportControls.toggle()
                    // Temporary fix to hide the status bar since `.statusBar(hidden: _)` is unreliable.
                    UIApplication.shared.isStatusBarHidden = !showTransportControls
                }
            }
    }

    private var transportControls: some View {
        TransportControls(playerOptionsIsSelected: $showSettings.animation(), viewModel: playlistPlayerViewModel)
    }

    private var settingsPanel: some View {
        SettingsScreen(playerViewModel: playlistPlayerViewModel)
            .cornerRadius(10)
            .padding([.leading, .trailing], 4)
            .frame(width: 350)
    }
}
