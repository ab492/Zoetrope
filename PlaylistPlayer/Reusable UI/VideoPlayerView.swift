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
            guard Current.featureFlags.drawingModeEnabled else { return }
            parent.playerViewModel.pause()
        }

        func drawingDidChange(drawing: Drawing) {
//            parent.bookmarkListViewModel.addBookmarkForDrawing(data: drawing.dataRepresentation())
        }

        func drawingDidEnd(drawing: Drawing) {
            guard Current.featureFlags.drawingModeEnabled else { return }
            parent.bookmarkListViewModel.addBookmarkForDrawing(drawing: drawing)
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
        uiView.overlayNotes = playerViewModel.overlayNotes
        uiView.overlayNoteColor = UIColor(playerViewModel.noteColor)
        uiView.updateTextLayer(with: bookmarkListViewModel.currentNotesFormattedForOverlay)

        // Note: Only drawing related code after this.
        guard Current.featureFlags.drawingModeEnabled else { return }
        uiView.drawingMode = playerViewModel.drawingOverlayMode

        guard let bookmark = bookmarkListViewModel.currentBookmarks.first,
              let drawing = bookmark.drawing else {
            print("NIL")
            uiView.updateDrawing(with: nil)
            return }

        guard drawing != uiView.drawing else { return }
        print("DID UPDATE")
        uiView.updateDrawing(with: drawing)
        
//        if let bookmarks = bookmarkListViewModel.currentBookmarks.first,
//           let data = bookmarks.drawing,
//           let drawing = Drawing(data: data) {
//            print("UPDATE DRAWING IN UI VIEW")
//            uiView.updateDrawing(with: drawing)
//        } else {
//            uiView.updateDrawing(with: nil)
//        }
    }
}
