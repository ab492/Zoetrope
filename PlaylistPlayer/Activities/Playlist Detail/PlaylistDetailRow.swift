//
//  PlaylistDetailRow.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 13/02/2021.
//

import SwiftUI

struct PlaylistDetailRow: View {

    var video: Video

    var body: some View {
        HStack {
            selectImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 56)
                .clipShape(
                    RoundedRectangle(cornerRadius: 3)
                )
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.white.opacity(0.2), lineWidth: 1))
            Text(video.filename)
                .foregroundColor(.primary)
            Spacer()
            Text(TimeFormatter.string(from: Int(video.duration.seconds)))
                .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
    }

    private func selectImage() -> Image {
        if let image = Current.thumbnailService.thumbnail(for: video) {
            return Image(uiImage: image)
        } else {
            return Image(systemName: "multiply.circle")
        }
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
