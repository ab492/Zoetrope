//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import PencilKit

struct CustomPlayerView: View {

    @StateObject var viewModel: PlaylistPlayerViewModel
    @State private var showTransportControls = true

    @State private var showViewerOptions = false

    @State private var isInDrawingMode = false
    @State private var drawing = PKCanvasView()

    @State private var isShowingBookmarkPanel = false


    var body: some View {
        ZStack {
            videoPlaybackView.zIndex(0)
            if isInDrawingMode { drawingView.zIndex(1) }
            transportControls.zIndex(2)
            viewerOptions.zIndex(2)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear { viewModel.play() }
        .onDisappear { viewModel.pause() }
    }

    private var controlsBar: some View {
        VStack(spacing: 10) {
            ViewerOptionsButton(systemImage: PlayerIcons.annotate, isSelected: $isInDrawingMode)
            ViewerOptionsButton(systemImage: PlayerIcons.bookmarks, isSelected: $isShowingBookmarkPanel)
//                .popover(isPresented: $isShowingBookmarkPanel,
//                         attachmentAnchor: .point(UnitPoint.center),
//                         arrowEdge: .trailing, content: {
//                            BookmarkEditorView(playlistPlayer: viewModel)
//                })
        }
        .padding()
        .frame(height: 300)
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
        .cornerRadius(10)
        .offset(x: -10)
    }

    private var videoPlaybackView: some View {
        CustomPlayerLayer(viewModel: viewModel)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.1)) {
                    showTransportControls.toggle()
                    // Temporary fix to hide the status bar since `.statusBar(hidden: _)` is unreliable.
                    UIApplication.shared.isStatusBarHidden = !showTransportControls
                }
            }
    }

    private var drawingView: some View {
        DrawingView(canvasView: $drawing)
    }

    @ViewBuilder
    private var transportControls: some View {
        if showTransportControls { TransportControls(playerOptionsIsSelected: $showViewerOptions, viewModel: viewModel) }
    }

    @ViewBuilder
    private var viewerOptions: some View {
        if showTransportControls && showViewerOptions  {
            HStack {
                Spacer()
                bookmarkPanel
                controlsBar // Push controls to right hand side
            }
        }
    }

    @ViewBuilder
    private var bookmarkPanel: some View {
        if showTransportControls && showViewerOptions && isShowingBookmarkPanel {
            BookmarkEditorView(playlistPlayer: viewModel)
                .padding()
                .frame(width: 300)
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
                .cornerRadius(10)
                .offset(x: -10)
        }
    }
}
