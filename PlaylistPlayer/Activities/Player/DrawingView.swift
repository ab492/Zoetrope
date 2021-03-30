//
//  DrawingView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 13/03/2021.
//

import SwiftUI
import PencilKit

//struct DrawingView: View {
//
////    @Binding var canvasView: PKCanvasView
//    @State var toolPickerIsActive = false
//    @State private var canvasView: PKCanvasView
//    @ObservedObject var viewModel: PlaylistPlayerViewModel
//
//    init(viewModel: PlaylistPlayerViewModel) {
//        _viewModel = ObservedObject(initialValue: viewModel)
//
//        var pkDrawing = PKDrawing()
//
//        let currentBookmarks = viewModel.currentBookmarks
//        if currentBookmarks.count > 0 {
//            for bookmark in currentBookmarks {
//                switch bookmark.noteType {
//                case .text(_):
//                    break
//                case .drawing(let data):
//                    print("HERE 😝")
//                    pkDrawing = try! PKDrawing(data: data)
//                }
//            }
//        }
//
//        let canvas = PKCanvasView()
//        canvas.drawing = pkDrawing
//
//        _canvasView = State(initialValue: canvas)
//    }
//    
//    var body: some View {
//        CanvasView(canvasView: $canvasView, toolPickerIsActive: $toolPickerIsActive, onChange: onChange)
//            .onAppear { toolPickerIsActive = true }
////            .onDisappear { toolPickerIsActive = false }
//    }
//
//    func onChange() {
//        viewModel.addBookmark(type: .drawing(canvasView.drawing.dataRepresentation()))
//    }
//}





//struct DrawingView: View {
//
//    @Binding var canvasView: PKCanvasView
//    @State private var pkActor: PKCanvasActor
//
//    init(canvasView: Binding<PKCanvasView>) {
//        self._canvasView = canvasView
//        _pkActor = State(initialValue: PKCanvasActor(canvasView: $canvasView))
//    }
//
//    var body: some View {
//        CanvasView(actor: pkActor, onChange: onChange)
//            .onAppear { pkActor.showToolPicker() }
//            .onDisappear { pkActor.hideToolPicker() }
//    }
//
//    func onChange() {
//        print("WHOOP CHANGE!!!")
//    }
//}





////class PKCanvasActor {
////    let canvasView: PKCanvasView
////    let toolPicker: PKToolPicker
////
////    init() {
////        let cv = PKCanvasView()
////        cv.backgroundColor = .clear
////        cv.isOpaque = true
////        canvasView = cv
////
////        let picker = PKToolPicker()
////        picker.isRulerActive = false
////        toolPicker = picker
////    }
////
////    func showToolPicker() {
////        toolPicker.setVisible(true, forFirstResponder: canvasView)
////        toolPicker.addObserver(canvasView)
////        canvasView.becomeFirstResponder()
////    }
////
////    func hideToolPicker() {
////        toolPicker.setVisible(false, forFirstResponder: canvasView)
////    }
////
////}
//
//struct PKCanvasActor {
//    @Binding var canvasView: PKCanvasView
//    let toolPicker: PKToolPicker
//
//    init(canvasView: Binding<PKCanvasView>) {
//        self._canvasView = canvasView
//
//        let picker = PKToolPicker()
//        picker.isRulerActive = false
//        toolPicker = picker
//
//        self.canvasView.backgroundColor = .clear
//        self.canvasView.isOpaque = true
//    }
//
//    func showToolPicker() {
//        toolPicker.setVisible(true, forFirstResponder: canvasView)
//        toolPicker.addObserver(canvasView)
//        canvasView.becomeFirstResponder()
//    }
//
//    func hideToolPicker() {
//        toolPicker.setVisible(false, forFirstResponder: canvasView)
//    }
//}
//
//struct CanvasView: UIViewRepresentable {
//
//    // MARK: - Coordinator
//
//    class Coordinator: NSObject, PKCanvasViewDelegate {
//        var canvasView: Binding<PKCanvasView>
//        let onChange: () -> Void
//
//        init(canvasView: Binding<PKCanvasView>, onChange: @escaping () -> Void) {
//            self.canvasView = canvasView
//            self.onChange = onChange
//        }
//
//        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
//            if canvasView.drawing.bounds.isEmpty == false {
//                onChange()
//            }
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(canvasView: actor.$canvasView, onChange: onChange)
//    }
//
//    let actor: PKCanvasActor
//    let onChange: () -> Void
//
//    func makeUIView(context: Context) -> PKCanvasView {
//        return actor.canvasView
//    }
//
//    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
//}
//
//
//

//
//
//
//
//
//
////struct CanvasView: UIViewRepresentable {
////    @Binding var canvasView: PKCanvasView
////    @State var toolPicker = PKToolPicker()
////
////    func makeUIView(context: Context) -> PKCanvasView {
////        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
////        showToolPicker()
////        #if targetEnvironment(simulator)
////        canvasView.drawingPolicy = .anyInput
////        #endif
////        return canvasView
////    }
////
////    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
////
////    func showToolPicker() {
////        toolPicker.setVisible(true, forFirstResponder: canvasView)
////        toolPicker.addObserver(canvasView)
////        canvasView.becomeFirstResponder()
////    }
////
////    func hideToolPicker() {
////        toolPicker.setVisible(false, forFirstResponder: canvasView)
////    }
////}
////
////struct DrawingView: View {
////
////    @State private var canvasView: PKCanvasView
////
////    init() {
////        let canvasView = PKCanvasView()
////        canvasView.backgroundColor = .clear
////        canvasView.isOpaque = false
////        _canvasView = State(initialValue: canvasView)
////    }
////
////    var body: some View {
////        CanvasView(canvasView: $canvasView)
////            .onDisappear {
////                print("Disappear") }
////    }
////
////
////}




