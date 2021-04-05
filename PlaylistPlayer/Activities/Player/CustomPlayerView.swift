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
    @StateObject private var bookmarkListViewModel: BookmarkListView.ViewModel

    @State private var viewerOptionsSelected = false
    @State private var bookmarkPanelSelected = false
    @State private var showTransportControls = true
    @State private var drawingModeIsSelected = false
    @State private var drawing = PKCanvasView()

    init(playlistPlayer: PlaylistPlayer) {
        _viewModel = StateObject(wrappedValue: PlaylistPlayerViewModel(playlistPlayer: playlistPlayer))
        _bookmarkListViewModel = StateObject(wrappedValue: BookmarkListView.ViewModel(playlistPlayer: playlistPlayer))
    }

    private var shouldShowBookmarkPanel: Bool {
        showTransportControls && viewerOptionsSelected && bookmarkPanelSelected
    }

    private var shouldShowViewerOptions: Bool {
        showTransportControls && viewerOptionsSelected
    }

    // MARK: - View

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                ZStack {
                    videoPlaybackView.zIndex(0)
//                    if drawingModeIsSelected { drawingView.zIndex(1) }
                }.zIndex(0)

                if showTransportControls {
                    transportControls.zIndex(1)
                }
            }
            Group {
                if shouldShowBookmarkPanel {
                    bookmarkPanel
                        .transition(.move(edge: .trailing))
                }
                if shouldShowViewerOptions {
                    controlsBar
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear { viewModel.play() }
        .onDisappear { viewModel.pause() }
    }

    private var controlsBar: some View {
        VStack(spacing: 20) {
            ViewerOptionsButton(systemImage: PlayerIcons.PlayerOptions.annotate, isSelected: $drawingModeIsSelected)
            ViewerOptionsButton(systemImage: PlayerIcons.PlayerOptions.bookmarks, isSelected: $bookmarkPanelSelected.animation())
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
        .cornerRadius(10)
    }

    private var videoPlaybackView: some View {
        CustomPlayerLayer(viewModel: viewModel)
            .background(Color.red)
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
        TransportControls(playerOptionsIsSelected: $viewerOptionsSelected.animation(), viewModel: viewModel)
    }

//    private var drawingView: some View {
//        DrawingView(viewModel: viewModel)
//    }

    private var bookmarkPanel: some View {
//        BookmarkListView(viewModel: bookmarkEditorViewModel)
//        BookmarkListView(bookmarkController: bookmarkController)
        BookmarkListView(viewModel: bookmarkListViewModel)
            .padding()
            .background(Color.green)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))

    }
}
