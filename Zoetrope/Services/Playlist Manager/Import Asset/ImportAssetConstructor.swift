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

    // MARK: - Init

    init(uuidConstructor: @escaping () -> UUID,
         durationCalculator: @escaping (URL) -> Time) {
        self.uuidConstructor = uuidConstructor
        self.durationCalculator = durationCalculator
    }

    convenience init() {
        self.init(uuidConstructor: { UUID() },
                  durationCalculator: { Time(seconds: AVAsset(url: $0).duration.seconds) })
    }

    // MARK: - Public

    func assetFor(sourceURL: URL) -> ImportAsset {
        let fileExtension = sourceURL.pathExtension
        let filename = uuidConstructor().uuidString.appending(".\(fileExtension)")
        let displayName = FileManager.default.displayName(atPath: sourceURL.path).trimmingCharacters(in: .whitespaces)
        let duration = durationCalculator(sourceURL)
        return ImportAsset(sourceURL: sourceURL, filename: filename, displayName: displayName, duration: duration)
    }
}
