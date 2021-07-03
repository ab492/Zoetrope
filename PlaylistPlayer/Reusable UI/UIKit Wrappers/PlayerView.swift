//
//  UIPlayerView.swift
//  Quickfire
//
//  Created by Andy Brown on 13/12/2020.
//

import UIKit
import AVFoundation
import PencilKit
import VideoQueuePlayer

protocol PlayerViewDelegate: AnyObject {
    func drawingDidStart()
    func drawingDidChange(drawing: Drawing)
    func drawingDidEnd(drawing: Drawing)
}

final class PlayerView: UIView {

    // MARK: - Properties

    private let foregroundView = UIView(frame: .zero)
    private let noteLabel = UILabel(frame: .zero)
    private let drawingView = DrawingView(frame: .zero)

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

    private(set) var drawing: Drawing? {
        didSet {
            guard drawing != oldValue else { return }
            print("UPDATE DRAWING WITHIN VIEW")

            if let drawing = drawing {
                drawingView.drawing = drawing
            } else {
                print("NOT HERE")
                drawingView.drawing = Drawing()
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

    var drawingMode: DrawingView.Configuration = .none  {
        didSet {
            guard drawingMode != oldValue else { return }
            updateDrawingDisplayMode()
            setNeedsLayout() // TODO: Set needs layout required?
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

        // Drawing view
        foregroundView.addSubview(drawingView)
        drawingView.delegate = self
        
        updateDrawingDisplayMode()
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

        // Drawing view
        drawingView.frame = CGRect(x: 0, y: 0, width: videoBounds.width, height: videoBounds.height)
    }

    // MARK: - Public

    func updateTextLayer(with text: String) {
        textString = text
    }

    func updateDrawing(with drawing: Drawing?) {
//        print("DRAWING: \(drawing)")
        self.drawing = drawing
    }

    private func updateDrawingDisplayMode() {
        drawingView.drawingDisplayMode = drawingMode
    }
}

extension PlayerView: DrawingViewDelegate {
    func drawingDidStart() {
        delegate?.drawingDidStart()
    }

    func drawingDidEnd(drawing: Drawing) {
        print("DRAWING DID END")
        delegate?.drawingDidEnd(drawing: drawing)
    }

    func drawingDidChange(drawing: Drawing) {
        delegate?.drawingDidChange(drawing: drawing)
    }
}

extension PlayerView: PlayerViewProtocol { }

