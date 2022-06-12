//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import PencilKit

struct CustomPlayerView: View {

    // MARK: - Types

    enum ViewerOption {
        case drawing
        case bookmarks
        case settings
        case none
    }

    // MARK: - State

    @StateObject private var playlistPlayerViewModel: PlaylistPlayerViewModel
    
    @State private var viewerOptionsSelected = false
    @State private var showTransportControls = true
    @State private var selectedViewerOption: ViewerOption = .none
    @State private var playerDimension = CGRect.zero

    private var shouldShowViewerOptions: Bool {
        showTransportControls && viewerOptionsSelected
    }

    private var shouldShowBookmarkPanel: Bool {
        shouldShowViewerOptions && selectedViewerOption == .bookmarks
    }

    private var shouldShowPlayerSettings: Bool {
        shouldShowViewerOptions && selectedViewerOption == .settings
    }

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
            Group {
                if shouldShowPlayerSettings {
                    settingsPanel
                        .transition(.move(edge: .trailing))
                }
                if shouldShowViewerOptions {
                    controlsBar
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear { playlistPlayerViewModel.play() }
        .onDisappear { playlistPlayerViewModel.pause() }
    }

    private var controlsBar: some View {
        VStack(spacing: 20) {
            ViewerOptionsButton(systemImage: PlayerIcons.PlayerOptions.settings,
                                isSelected: selectedViewerOption == .settings,
                                onTap: toggleSettings)
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(Color.secondarySystemBackground)
        .cornerRadius(10)
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
        TransportControls(playerOptionsIsSelected: $viewerOptionsSelected.animation(), viewModel: playlistPlayerViewModel)
    }

    private var settingsPanel: some View {
        ViewerOptionsScreen(playerViewModel: playlistPlayerViewModel)
            .cornerRadius(10)
            .padding([.leading, .trailing], 4)
            .frame(width: 350)
    }

    // MARK: - Helpers

    private func toggleSettings() {
        withAnimation {
            switch selectedViewerOption {
            case .settings:
                selectedViewerOption = .none
            default:
                selectedViewerOption = .settings
            }
        }
    }

}
