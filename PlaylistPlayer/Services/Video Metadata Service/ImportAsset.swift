//
//  ImportAsset.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/06/2022.
//

import Foundation

final class ImportAsset {
    let sourceURL: URL
    let destinationURL: URL
    let title: String
    let duration: Time

    init(sourceURL: URL, destinationURL: URL, title: String, duration: Time) {
        self.sourceURL = sourceURL
        self.destinationURL = destinationURL
        self.title = title
        self.duration = duration
    }
}
