//
//  DrawingView.swift
//  QueueTet
//
//  Created by Andy Brown on 02/05/2021.
//

import Foundation
import PencilKit

protocol DrawingViewDelegate: AnyObject {
    func drawingDidStart()
    func drawingDidEnd(drawing: Drawing)
    func drawingDidChange(drawing: Drawing)
}

/// A transparent view layer that provides capabilities for drawing and displaying drawings.
class DrawingView: UIView {

    enum Configuration {
        /// An editable drawing mode.
        case drawing

        /// A static display of the drawing which can not be edited.
        case display

        /// Turns drawing and display of the layer off (including hiding the tool picker).
        case none
    }

    // MARK: - Private Properties

    private let canvasView = PKCanvasView(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let toolPicker = PKToolPicker()

    // Here we store an internal copy as the source of truth regarding the
    // `originalCanvasBounds`. If we accessed `drawing` via the getter, then we'd be
    // getting the current size back when trying to layout.
    private var _internalDrawing: Drawing = Drawing() {
        didSet {
            imageView.image = drawing.imageRepresentation()
        }
    }

    // MARK: - Public Properties

    var drawingDisplayMode: Configuration = .drawing {
        didSet {
            updateConfiguration()
        }
    }

    var drawing: Drawing {
        get {
            Drawing(pkDrawing: canvasView.drawing, originalCanvasBounds: bounds)
        }
        set {
            _internalDrawing = newValue
            setNeedsLayout()
            layoutIfNeeded()
//            let scaledDrawing = newValue.scaledDrawingForHeight(height: bounds.height)
//            canvasView.drawing = newValue.pkDrawing // TODO: Put this back!
        }
    }

    var toolPickerIsVisible = true {
        didSet { updateToolPickerVisibility() }
    }

    weak var delegate: DrawingViewDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {

        // Canvas
        addSubview(canvasView)
        canvasView.isOpaque = false
        canvasView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        canvasView.becomeFirstResponder()
        canvasView.delegate = self

        // Tool picker
        toolPicker.addObserver(canvasView)
        updateToolPickerVisibility()

        // Image view
        addSubview(imageView)
        imageView.backgroundColor = UIColor.orange.withAlphaComponent(0.3)

        // Configuration
        updateConfiguration()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        // Layout canvas view
        canvasView.frame = bounds
        canvasView.contentSize = bounds.size

        // Layout based on `_internalDrawing`, since the public getter for `drawing` will
        // return the current bounds which means the layout is incorrect.
        canvasView.drawing = _internalDrawing.scaledDrawingForHeight(height: bounds.height)

        // Layout image view
        imageView.frame = bounds
    }

    // MARK: - Private

    private func updateToolPickerVisibility() {
        toolPicker.setVisible(toolPickerIsVisible, forFirstResponder: canvasView)
    }

    private func updateConfiguration() {
        switch drawingDisplayMode {
        case .display:
            canvasView.isHidden = true
            imageView.isHidden = false
            toolPickerIsVisible = false
        case .drawing:
            canvasView.isHidden = false
            imageView.isHidden = true
            toolPickerIsVisible = true
        case .none:
            canvasView.isHidden = true
            imageView.isHidden = true
            toolPickerIsVisible = false
        }
    }

    var manuallyChangedDrawing = false
}

// MARK: - PKCanvasViewDelegate

extension DrawingView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        // Don't report any changes if we're not in drawing mode.
        guard drawingDisplayMode == .drawing,
//              manuallyChangedDrawing == true,
              canvasView.drawing.strokes.isEmpty == false else { return }
        _internalDrawing = Drawing(pkDrawing: canvasView.drawing, originalCanvasBounds: bounds)
        delegate?.drawingDidChange(drawing: drawing)
    }

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
//        manuallyChangedDrawing = true

//        guard configuration == .drawing else { return }
        delegate?.drawingDidStart()
    }

    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
//        manuallyChangedDrawing = false

//        guard configuration == .drawing else { return }
        delegate?.drawingDidEnd(drawing: drawing)
    }
}

