//
//  ImportAsset.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/06/2022.
//

import Foundation

final class ImportAsset {
    let sourceURL: URL
    let filename: String
    let displayName: String
    let duration: Time

    init(sourceURL: URL, filename: String, displayName: String, duration: Time) {
        self.sourceURL = sourceURL
        self.filename = filename
        self.displayName = displayName
        self.duration = duration
    }
}
