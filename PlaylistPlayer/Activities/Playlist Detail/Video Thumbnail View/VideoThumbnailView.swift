//
//  LoadingImageView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 19/02/2021.
//

import SwiftUI

struct VideoThumbnailView: View {

    // MARK: - Types

    enum State {
        case success(Image)
        case loading
        case failure(Image?)
    }

    // MARK: - State

    @StateObject var viewModel: ViewModel

    // MARK: - View

    var body: some View {
        switch viewModel.imageState {
        case .success, .failure:
            if let image = selectImage() {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        case .loading:
            loadingView
        }
    }

    // MARK: - Helpers

    private func selectImage() -> Image? {
        switch viewModel.imageState {
        case .success(let image):
            return image
        case .loading:
            return nil
        case .failure(let maybeImage):
            return maybeImage ?? Image(systemName: "multiply.circle")
        }
    }

    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
    }
}

