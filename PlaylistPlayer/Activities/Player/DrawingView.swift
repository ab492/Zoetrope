//
//  NewDrawingView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 08/04/2021.
//

import SwiftUI
import PencilKit

struct DrawingView: View {

    @StateObject var viewModel: DrawingModeViewModel
    @State var toolPicker = PKToolPicker()
    @State private var toolPickerIsActive = false

    var body: some View {
        CanvasView(canvasView: $viewModel.canvasView,
                   toolPickerIsActive: $toolPickerIsActive,
                   toolPicker: $toolPicker,
                   onChange: onChange,
                   onDrawingStarted: onDrawingStart,
                   onDrawingComplete: onDrawingComplete)
            .background(Color.blue.opacity(0.2))
            .onAppear {
                toolPickerIsActive = true
            }
    }

    func onChange() {
    }

    func onDrawingStart() {
        viewModel.drawingDidStart()
    }

    func onDrawingComplete() {
        viewModel.drawingDidComplete()
    }
}
