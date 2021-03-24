//
//  CanvasView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 13/03/2021.
//

import SwiftUI
import PencilKit

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

struct DrawingView: View {

    @Binding var canvasView: PKCanvasView
    @State var toolPickerIsActive = false


    var body: some View {
        CanvasView(canvasView: $canvasView, toolPickerIsActive: $toolPickerIsActive, onChange: onChange)
            .onAppear { toolPickerIsActive = true }
//            .onDisappear { toolPickerIsActive = false }
    }

    func onChange() {
        print("WHOOP CHANGE!!!")
    }
}





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




