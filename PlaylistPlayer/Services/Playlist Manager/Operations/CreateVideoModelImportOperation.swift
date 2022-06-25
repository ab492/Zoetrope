//
//  CreateVideoModelImportOperation.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/06/2022.
//

import Foundation

final class CreateVideoModelImportOperation: Operation {

    // MARK: - Properties

    private let importAsset: ImportAsset

    var onVideoModelCreated: ((Video) -> Void)?

    // MARK: - Init

    init(importAsset: ImportAsset) {
        self.importAsset = importAsset
    }

    // MARK: - Main

    override func main() {
        // TODO: Update filename to title, add duration metadata... WHAT IS ID USED FOR?
        let videoModel = Video(filename: importAsset.displayName, duration: importAsset.duration, underlyingFilename: importAsset.filename)

        if let onVideoModelCreated = onVideoModelCreated {
            DispatchQueue.main.async {
                onVideoModelCreated(videoModel)
            }
        }
    }



}