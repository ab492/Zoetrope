//
//  LoadingImageView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 19/02/2021.
//

import SwiftUI

struct VideoThumbnailView: View {

    @ObservedObject private var thumbnailService = Current.thumbnailService

    let video: Video

    var body: some View {
        if thumbnailIsLoading {
            loadingView
        } else {
            successOrFailureImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
    }

    private var successOrFailureImage: Image {
        if let image = thumbnailService.thumbnail(for: video) {
            return Image(uiImage: image)
        } else {
            return Image(systemName: "multiply.circle")
        }
    }

    private var thumbnailIsLoading: Bool {
        thumbnailService.processingThumbnails.contains(video)
    }
}

