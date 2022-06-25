//
//  PlaylistDetailRowViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/03/2021.
//

import Foundation

extension PlaylistDetailRow {

    class ViewModel: ObservableObject {

        private let video: VideoModel

        init(video: VideoModel) {
            self.video = video
        }

        // MARK: - Public

        var titleLabel: String {
            video.displayName
        }

        var durationLabel: String {
            TimeFormatter.string(from: Int(video.duration.seconds))
        }
    }
}
