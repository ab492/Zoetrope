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

    private let baseURL: URL
    private let importAsset: ImportAsset

    // MARK: - Init

    init(baseURL: URL, importAsset: ImportAsset) {
        self.baseURL = baseURL
        self.importAsset = importAsset
    }

    // MARK: - Main
    
    override func main() {
        // TODO: Loop around to handle errors
        do {
            try FileManagerWrappedImpl().copyItem(at: importAsset.sourceURL, to: baseURL.appendingPathComponent(importAsset.filename))
        } catch let error {
            print("ERROR: \(error)")
        }
        
    }

}
