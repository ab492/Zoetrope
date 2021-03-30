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
        private let toolPicker: PKToolPicker

        deinit {
            toolPicker.setVisible(false, forFirstResponder: canvasView.wrappedValue)
            toolPicker.removeObserver(canvasView.wrappedValue)
        }

        init(canvasView: Binding<PKCanvasView>, toolPicker: PKToolPicker, onChange: @escaping () -> Void) {
            self.canvasView = canvasView
            self.onChange = onChange
            self.toolPicker = toolPicker
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if canvasView.drawing.bounds.isEmpty == false {
                onChange()
            }
        }
    }

    @Binding var canvasView: PKCanvasView
    @Binding var toolPickerIsActive: Bool
    private let toolPicker = PKToolPicker()

    let onChange: () -> Void

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
        Coordinator(canvasView: $canvasView, toolPicker: toolPicker, onChange: onChange)
    }
}
