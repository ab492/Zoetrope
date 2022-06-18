//
//  ImportAssetConstructor.swift
//  Shoebox
//
//  Created by Andy Brown on 31/12/2021.
//

import Foundation
import AVFoundation

final class ImportAssetConstructor {

    // MARK: - Properties

    private let uuidConstructor: () -> UUID
    private let durationCalculator: (URL) -> Time
    private let destinationDirectory: URL

    // MARK: - Init

    init(destinationDirectory: URL,
         uuidConstructor: @escaping () -> UUID,
         durationCalculator: @escaping (URL) -> Time) {
        self.destinationDirectory = destinationDirectory
        self.uuidConstructor = uuidConstructor
        self.durationCalculator = durationCalculator
    }

    convenience init(destinationDirectory: URL) {
        self.init(destinationDirectory: destinationDirectory,
                  uuidConstructor: { UUID() },
                  durationCalculator: { Time(seconds: AVAsset(url: $0).duration.seconds) })
    }

    // MARK: - Public

    func assetFor(sourceURL: URL) -> ImportAsset {
        let fileExtension = sourceURL.pathExtension
        let destinationURL = destinationDirectory.appendingPathComponent(uuidConstructor().uuidString).appendingPathExtension(fileExtension)
        let title = FileManager.default.displayName(atPath: sourceURL.path).trimmingCharacters(in: .whitespaces)
        let duration = durationCalculator(sourceURL)
        return ImportAsset(sourceURL: sourceURL, destinationURL: destinationURL, title: title, duration: duration)
    }
}
