//
//  Drawing.swift
//  QueueTet
//
//  Created by Andy Brown on 02/05/2021.
//

import Foundation
import PencilKit

struct Drawing: Codable, Equatable {

    // MARK: - Properties

    let pkDrawing: PKDrawing // TODO: Make this private again
    private let originalCanvasBounds: CGRect

    // MARK: - Init

    init() {
        self.pkDrawing = PKDrawing()
        self.originalCanvasBounds = .zero
    }

    init(pkDrawing: PKDrawing, originalCanvasBounds: CGRect) {
        self.pkDrawing = pkDrawing
        self.originalCanvasBounds = originalCanvasBounds
    }

    init?(data: Data) {
        let decoder = JSONDecoder()
        if let decodedDrawing = try? decoder.decode(Drawing.self, from: data) {
            self = decodedDrawing
        } else {
            return nil
        }
    }

    // MARK: - Public

    func scaledDrawingForHeight(height: CGFloat) -> PKDrawing {
        scaleDrawing(canvasHeight: height)
    }

    func imageRepresentation() -> UIImage? {
        guard originalCanvasBounds != .zero else { return nil }
        return pkDrawing.image(from: originalCanvasBounds, scale: UIScreen.main.scale)
    }

    func dataRepresentation() -> Data {
        let dataRepresentation = try? JSONEncoder().encode(self)
        return dataRepresentation ?? Data()
    }

    // MARK: - Private

    private func scaleDrawing(canvasHeight: CGFloat) -> PKDrawing {
        let scaleFactor = canvasHeight / originalCanvasBounds.height

        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let scaledDrawing = pkDrawing.transformed(using: transform)
        return scaledDrawing
    }
}
