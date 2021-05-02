//
//  DrawingView.swift
//  QueueTet
//
//  Created by Andy Brown on 02/05/2021.
//

import Foundation
import PencilKit

protocol DrawingViewDelegate: class {
    func drawingDidStart()
    func drawingDidEnd()
    func drawingDidChange(drawing: Drawing)
}

/// A transparent view layer that provides capabilities for drawing and displaying drawings.
class DrawingView: UIView {

    enum Configuration {
        /// An editable drawing mode.
        case drawing

        /// A static display of the drawing which can not be edited.
        case display
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

    var configuration: Configuration = .drawing {
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
            let scaledDrawing = newValue.scaledDrawingForHeight(height: bounds.height)
            canvasView.drawing = scaledDrawing
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
        switch configuration {
        case .display:
            canvasView.isHidden = true
            imageView.isHidden = false
            toolPickerIsVisible = false
        case .drawing:
            canvasView.isHidden = false
            imageView.isHidden = true
            toolPickerIsVisible = true
        }
    }
}

// MARK: - PKCanvasViewDelegate

extension DrawingView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        _internalDrawing = Drawing(pkDrawing: canvasView.drawing, originalCanvasBounds: bounds)
        delegate?.drawingDidChange(drawing: drawing)
    }

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        delegate?.drawingDidStart()
    }

    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        delegate?.drawingDidEnd()
    }
}

