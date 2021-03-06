//
//  PlaylistDetailRowViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/03/2021.
//

import Foundation

extension PlaylistDetailRow {

    class ViewModel: ObservableObject {

        private let video: Video

        init(video: Video) {
            self.video = video
        }

        // MARK: - Public

        var titleLabel: String {
            video.filename
        }

        var durationLabel: String {
            TimeFormatter.string(from: Int(video.duration.seconds))
        }
    }
}
