//
//  GenerateThumbnailOperation.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/02/2021.
//

import UIKit

final class GenerateThumbnailOperation: Operation {

    // MARK: - Properties

    private let thumbnailGenerator: ThumbnailGenerator
    private let inputURL: URL

    /// This callback will be run **on the main thread** when the operation completes.
    var onComplete: ((UIImage?) -> Void)?

    // MARK: - Init

    init(thumbnailGenerator: ThumbnailGenerator, url: URL) {
        self.thumbnailGenerator = thumbnailGenerator
        self.inputURL = url
        super.init()
    }

    convenience init(url: URL) {
        self.init(thumbnailGenerator: ThumbnailGeneratorImpl(), url: url)
    }

    // MARK: - Main

    override func main() {
        guard let outputImage = thumbnailGenerator.thumbnail(for: inputURL) else {
            print("Failed to generate thumbnail for URL: \(inputURL)")
            DispatchQueue.main.async { [weak self] in
                self?.onComplete?(nil)
            }
            return
        }

        if let onComplete = onComplete {
            DispatchQueue.main.async {
                onComplete(outputImage)
            }
        }
    }
}
