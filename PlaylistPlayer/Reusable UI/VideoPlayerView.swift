//
//  VideoPlayerView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import Combine
import PencilKit

struct VideoPlayerView: UIViewRepresentable {

    // MARK: - Coordinator

    class Coordinator: NSObject, PlayerViewDelegate {

        var parent: VideoPlayerView

        init(_ parent: VideoPlayerView) {
            self.parent = parent
        }

        func drawingDidStart() {
            parent.playerViewModel.pause()
        }

        func drawingDidComplete(drawing: PKDrawing) {
            parent.bookmarkListViewModel.addBookmarkForDrawing(data: drawing.dataRepresentation())
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Properties

    @ObservedObject var playerViewModel: PlaylistPlayerViewModel
    @ObservedObject var bookmarkListViewModel: BookmarkListView.ViewModel

    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        playerViewModel.setVideoPlayer(view: view)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        uiView.isInDrawingMode = playerViewModel.isInDrawingMode
        uiView.overlayNotes = playerViewModel.overlayNotes
        uiView.overlayNoteColor = UIColor(playerViewModel.noteColor)
        uiView.updateTextLayer(with: bookmarkListViewModel.currentNotesFormattedForOverlay)
        
        if let bookmarks = bookmarkListViewModel.currentBookmarks.first,
           let data = bookmarks.drawing,
           let drawing = try? PKDrawing(data: data) {
            uiView.updateDrawing(with: drawing)
        }
    }
}
