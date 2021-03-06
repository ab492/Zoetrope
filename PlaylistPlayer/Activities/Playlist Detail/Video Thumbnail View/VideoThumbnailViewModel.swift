//
//  VideoThumbnailViewModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 06/03/2021.
//

import Foundation
import SwiftUI

extension VideoThumbnailView {

    class ViewModel: ObservableObject {

        // MARK: - Properties and Init

        private let video: Video

        init(video: Video) {
            self.video = video

            Current.thumbnailService.addObserver(self)
        }

        // MARK: - Public

        // TODO: This isn't idea as it's containing some view data (Image), but it serves its purpose.
        var imageState: VideoThumbnailView.State {
            if Current.thumbnailService.processingThumbnails.contains(video) {
                return .loading
            } else if let successThumbnail = Current.thumbnailService.thumbnail(for: video) {
                return .success(Image(uiImage: successThumbnail))
            } else {
                return .failure(nil)
            }
        }
    }
}

// MARK: - ThumbnailServiceObserver

extension VideoThumbnailView.ViewModel: ThumbnailServiceObserver {
    func processingThumbnailsDidUpdate(thumbnails: [Video]) {
        objectWillChange.send()
    }
}
