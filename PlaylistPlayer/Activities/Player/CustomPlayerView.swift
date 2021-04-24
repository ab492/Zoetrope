//
//  CustomPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import PencilKit

class DrawingModeViewModel: ObservableObject {

    // MARK: - Types

    enum CurrentDrawingState: Equatable {
        case hasDrawing(PKDrawing)
        case hasNoDrawing
    }

    private var playlistPlayer: PlaylistPlayer
    private var bookmarkListViewModel: BookmarkListView.ViewModel
//    private var videoSize: () -> CGRect

    private var _currentDrawingState: CurrentDrawingState = .hasNoDrawing {
        didSet {
            guard _currentDrawingState != oldValue else { return }
            switch _currentDrawingState {
            case .hasDrawing(let drawing):
//                let drawingResized = drawing.transformed(using: CGAffineTransform(scaleX: 1, y: 1))
                canvasView.drawing = drawing
                drawingImageRepresentation = drawing.image(from: CGRect(x: 0, y: 0, width: 800, height: 800), scale: 0.5)

//                let transformScale = CGAffineTransform(scaleX: 0.5, y: 0.5)
//                canvasView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
//                canvasView.frame = canvasView.frame.applying(transformScale)
//                canvasView.drawing.transform(using: transformScale)

            case .hasNoDrawing:
                canvasView.drawing = PKDrawing()
                drawingImageRepresentation = nil
            }
        }
    }

    var canvasView = PKCanvasView()
    var drawingImageRepresentation: UIImage?

    init(playlistPlayer: PlaylistPlayer, bookmarkListViewModel: BookmarkListView.ViewModel) {
        self.playlistPlayer = playlistPlayer
        self.bookmarkListViewModel = bookmarkListViewModel
//        self.videoSize = videoSize
        self.playlistPlayer.addObserver(self)
    }

    func drawingDidStart() {
        playlistPlayer.pause()
    }

    func drawingDidComplete() {
        withAnimation {
            bookmarkListViewModel.addBookmarkForDrawing(data: canvasView.drawing.dataRepresentation())
        }
    }

}

extension DrawingModeViewModel: PlaylistPlayerObserver {

    func playbackPositionDidChange(to time: MediaTime) {

        if let bookmarkWithDrawing = bookmarkListViewModel.currentBookmarks.first(where: { $0.hasDrawing }),
           let drawingData = bookmarkWithDrawing.drawing,
           let pkDrawing = try? PKDrawing(data: drawingData) {
            _currentDrawingState = .hasDrawing(pkDrawing)
        } else {
            _currentDrawingState = .hasNoDrawing
        }
    }
}


struct CustomPlayerView: View {

    // MARK: - Types

    enum ViewerOption {
        case drawing
        case bookmarks
        case none
    }

    // MARK: - State

    @StateObject private var playlistPlayerViewModel: PlaylistPlayerViewModel
    @StateObject private var bookmarkListViewModel: BookmarkListView.ViewModel
    @StateObject private var drawingModeViewModel: DrawingModeViewModel

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

    private var shouldShowDrawingView: Bool {
        shouldShowViewerOptions && selectedViewerOption == .drawing
    }

    // MARK: - Init

    init(playlistPlayer: PlaylistPlayer) {
        let playlistPlayerViewModel = StateObject(wrappedValue: PlaylistPlayerViewModel(playlistPlayer: playlistPlayer))
        _playlistPlayerViewModel = playlistPlayerViewModel
        let viewModel = BookmarkListView.ViewModel(playlistPlayer: playlistPlayer)
        _bookmarkListViewModel = StateObject(wrappedValue: viewModel)
//        let closure = playlistPlayerViewModel.videoSize?() ?? CGRect.zero
        _drawingModeViewModel = StateObject(wrappedValue: DrawingModeViewModel(playlistPlayer: playlistPlayer,
                                                                               bookmarkListViewModel: viewModel))
    }

    // MARK: - View

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                ZStack {
                    videoPlaybackView.zIndex(0)
                    if shouldShowDrawingView { drawingView.zIndex(1) }
//                    if shouldShowBookmarkPanel { bookmarkDrawingView.zIndex(1) }
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
        .onAppear { playlistPlayerViewModel.play() }
        .onDisappear { playlistPlayerViewModel.pause() }
    }

    private var controlsBar: some View {
        VStack(spacing: 20) {
            ViewerOptionsButton(systemImage: PlayerIcons.PlayerOptions.annotate,
                                isSelected: selectedViewerOption == .drawing,
                                onTap: toggleDrawing)
            ViewerOptionsButton(systemImage: PlayerIcons.PlayerOptions.bookmarks,
                                isSelected: selectedViewerOption == .bookmarks,
                                onTap: toggleBookmarks)
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(Color.secondarySystemBackground)
//        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
        .cornerRadius(10)
    }

    private var videoPlaybackView: some View {
        CustomPlayerLayer(viewModel: playlistPlayerViewModel)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.1)) {
                    // Disable taps while drawing mode is active.
                    guard shouldShowDrawingView == false else { return }

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

    private var drawingView: some View {
        let videoSize = playlistPlayerViewModel.videoSize?() ?? CGRect(x: 0, y: 0, width: 0, height: 0)

        return Group {
            Spacer()
            DrawingView(viewModel: drawingModeViewModel)
                .frame(width: videoSize.width, height: videoSize.height)
            Spacer()
        }
    }

    private var bookmarkDrawingView: some View {
        let videoSize = playlistPlayerViewModel.videoSize?() ?? CGRect(x: 0, y: 0, width: 0, height: 0)

        return Group {
            Spacer()
//            Color.blue
            StaticDrawingOverlay(viewModel: drawingModeViewModel)
                .frame(height: videoSize.height)
//                .frame(width: videoSize.width, height: videoSize.height)
            Spacer()
        }
    }

    private var bookmarkPanel: some View {
        BookmarkListView(viewModel: bookmarkListViewModel)
            .cornerRadius(10)
            .padding([.leading, .trailing], 4)
//            .padding(20)

//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
    }

    // MARK: - Helpers

    private func toggleBookmarks() {
        withAnimation {
            switch selectedViewerOption {
            case .bookmarks: selectedViewerOption = .none
            default: selectedViewerOption = .bookmarks
            }
        }
    }

    private func toggleDrawing() {
        withAnimation {
            switch selectedViewerOption {
            case .drawing: selectedViewerOption = .none
            default: selectedViewerOption = .drawing
            }
        }
    }


}
