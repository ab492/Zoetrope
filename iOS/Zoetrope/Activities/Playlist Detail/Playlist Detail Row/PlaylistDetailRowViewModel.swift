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
        private let timeFormatter = TimeFormatter()

        init(video: VideoModel) {
            self.video = video
        }

        // MARK: - Public

        var titleLabel: String {
            video.displayName
        }

        var durationLabel: String {
            timeFormatter.string(from: Int(video.duration.seconds))
        }
        
        var accessibilityLabel: String {
            "\(titleLabel). \(timeFormatter.accessibilityString(from: video.duration))"
        }
    }
}
