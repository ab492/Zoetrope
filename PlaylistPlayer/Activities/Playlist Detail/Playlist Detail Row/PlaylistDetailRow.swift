//
//  PlaylistDetailRow.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 13/02/2021.
//

import SwiftUI

struct PlaylistDetailRow: View {

    @StateObject private var viewModel: PlaylistDetailRow.ViewModel
    @StateObject private var videoThumbnailViewModel: VideoThumbnailView.ViewModel

    init(video: Video) {
        _viewModel = StateObject(wrappedValue: ViewModel(video: video))
        _videoThumbnailViewModel = StateObject(wrappedValue: VideoThumbnailView.ViewModel(video: video))
    }

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                VideoThumbnailView(viewModel: videoThumbnailViewModel)
                .frame(width: 100, height: 56)
                .clipShape(
                    RoundedRectangle(cornerRadius: 3)
                )
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.white.opacity(0.2), lineWidth: 1))
                Text(viewModel.titleLabel)
                .foregroundColor(.primary)
            }
            Spacer()
            Text(viewModel.durationLabel)
                .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
    }

}

fileprivate extension View {
    func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
