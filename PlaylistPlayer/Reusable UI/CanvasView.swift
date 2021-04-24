//
//  CanvasView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/03/2021.
//

import PencilKit
import SwiftUI

struct CanvasView: UIViewRepresentable {

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var canvasView: Binding<PKCanvasView>
        let onChange: () -> Void
        let onDrawingStarted: () -> Void
        let onDrawingComplete: () -> Void
        var toolPicker: Binding<PKToolPicker>

        deinit {
            toolPicker.wrappedValue.setVisible(false, forFirstResponder: canvasView.wrappedValue)
            toolPicker.wrappedValue.removeObserver(canvasView.wrappedValue)
        }

        init(canvasView: Binding<PKCanvasView>,
             toolPicker: Binding<PKToolPicker>,
             onChange: @escaping () -> Void,
             onDrawingStarted: @escaping () -> Void,
             onDrawingComplete: @escaping () -> Void) {
            self.canvasView = canvasView
            self.onChange = onChange
            self.toolPicker = toolPicker
            self.onDrawingStarted = onDrawingStarted
            self.onDrawingComplete = onDrawingComplete
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if canvasView.drawing.bounds.isEmpty == false {
                onChange()
            }
        }

        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            onDrawingStarted()
        }

        func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            onDrawingComplete()
        }
    }

    @Binding var canvasView: PKCanvasView
    @Binding var toolPickerIsActive: Bool
    @Binding var toolPicker: PKToolPicker

    let onChange: () -> Void
    let onDrawingStarted: () -> Void
    let onDrawingComplete: () -> Void

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = true
        canvasView.delegate = context.coordinator
        showToolPicker()

        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        toolPicker.setVisible(toolPickerIsActive, forFirstResponder: uiView)
    }

    func showToolPicker() {
      toolPicker.setVisible(true, forFirstResponder: canvasView)
      toolPicker.addObserver(canvasView)
      canvasView.becomeFirstResponder()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvasView,
                    toolPicker: $toolPicker,
                    onChange: onChange,
                    onDrawingStarted: onDrawingStarted,
                    onDrawingComplete: onDrawingComplete)
    }
}
