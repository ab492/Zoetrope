//
//  UIPlayerView.swift
//  Quickfire
//
//  Created by Andy Brown on 13/12/2020.
//

import UIKit
import AVFoundation
import PencilKit

protocol PlayerViewDelegate: class {
    func drawingDidStart()
    func drawingDidComplete(drawing: PKDrawing)
}

final class PlayerView: UIView {

    // MARK: - Properties

    private let foregroundView = UIView()
    private let noteLabel = UILabel()
    private var canvasView = PKCanvasView()
    private let toolPicker = PKToolPicker()
    private var previousCanvasHeight: CGFloat = .zero

    // Here we use property observers to only update the label if the text has changed.
    // This prevents triggering unnecessary layout passes.
    private var textString: String? {
        didSet {
            guard textString != oldValue else { return }
            noteLabel.text = textString
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    private var drawing: PKDrawing? {
        didSet {
            guard drawing != oldValue else { return }
            if let drawing = drawing {
                canvasView.drawing = drawing
            }
        }
    }

    var overlayNotes: Bool = false {
        didSet {
            noteLabel.isHidden = !overlayNotes
        }
    }

    var overlayNoteColor: UIColor = .white {
        didSet {
            noteLabel.textColor = overlayNoteColor
        }
    }

    var isInDrawingMode = false {
        didSet {
            guard isInDrawingMode != oldValue else { return }
            updateCanvasView()
            setNeedsLayout()
        }
    }

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    weak var delegate: PlayerViewDelegate?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {

        addSubview(foregroundView)

        // Note label
        foregroundView.addSubview(noteLabel)
        noteLabel.numberOfLines = 0
        noteLabel.textAlignment = .center
        noteLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        noteLabel.textColor = overlayNoteColor
        noteLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        noteLabel.layer.shadowOpacity = 1
        noteLabel.layer.shadowColor = UIColor.black.cgColor
        noteLabel.layer.shadowRadius = 2

        // Canvas view
        foregroundView.addSubview(canvasView)
        canvasView.isOpaque = false
        canvasView.delegate = self
        toolPicker.addObserver(canvasView)
        updateCanvasView()
    }

    // MARK: - PlayerLayer Overrides

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        // Foreground view
        let videoBounds = playerLayer.videoRect
        foregroundView.frame = videoBounds

        // Note label
        let labelSizeFittingBounds = noteLabel.sizeThatFits(videoBounds.size)
        noteLabel.bounds = CGRect(x: 0, y: 0, width: labelSizeFittingBounds.width, height: labelSizeFittingBounds.height)
        let xPos = videoBounds.midX - (noteLabel.bounds.width / 2)
        noteLabel.frame.origin.x = xPos
        noteLabel.frame.origin.y = 10

        // Canvas view
        canvasView.frame = CGRect(x: 0, y: 0, width: videoBounds.width, height: videoBounds.height)
        canvasView.contentSize = playerLayer.videoRect.size // Content size is the actual part we can draw on.
        scaleDrawing(canvasHeight: playerLayer.videoRect.height)
    }

    private func scaleDrawing(canvasHeight : CGFloat) {
        let scaleFactor = canvasHeight / previousCanvasHeight

        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        canvasView.drawing = canvasView.drawing.transformed(using: transform)


//        canvasView.drawing.transform(using: transform)

        previousCanvasHeight = canvasHeight
    }

    // MARK: - Public

    func updateTextLayer(with text: String) {
        textString = text
    }

    func updateDrawing(with drawing: PKDrawing) {
//        self.drawing = drawing
    }

    // MARK: - Private

    private func updateCanvasView() {
        if isInDrawingMode {
            canvasView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            canvasView.isHidden = false
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            canvasView.becomeFirstResponder()
        } else {
            canvasView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            canvasView.isHidden = true
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            canvasView.resignFirstResponder()
        }
    }
}

extension PlayerView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) { }

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            delegate?.drawingDidStart()
    }

    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        delegate?.drawingDidComplete(drawing: canvasView.drawing)
    }
}

