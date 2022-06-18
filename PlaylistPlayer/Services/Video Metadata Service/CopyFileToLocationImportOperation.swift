//
//  CopyFileToLocationOperation.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/06/2022.
//

import Foundation
import ABExtensions

final class CopyFileToLocationImportOperation: Operation {

    // MARK: - Properties

    private let fileManager: FileManagerWrapped
    private let importAsset: ImportAsset

    // MARK: - Init

    init(importAsset: ImportAsset, fileManager: FileManagerWrapped) {
        self.fileManager = fileManager
        self.importAsset = importAsset
    }

    convenience init(importAsset: ImportAsset) {
        self.init(importAsset: importAsset, fileManager: FileManagerWrappedImpl())
    }

    override func main() {
        // TODO: Loop around to handle errors
        try? fileManager.copyItem(at: importAsset.sourceURL, to: importAsset.destinationURL)
    }

}
