//
//  BookmarkListRow.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 20/03/2021.
//

import SwiftUI

struct BookmarkListRow: View {

    // MARK: - Properties

    let timeIn: String
    let timeOut: String
    let note: String
    let onEditTapped: () -> Void
    let onGoToStart: () -> Void
    let onGoToEnd: () -> Void

    // MARK: - View

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            // Time labels
            HStack {
                Text(timeIn)
                Text("/")
                Text(timeOut)
                Spacer()
                editButton
            }
            .font(.system(size: 17, weight: .medium, design: .default))

            // Note label
            Text(note)
                .font(.system(size: 17, weight: .regular, design: .default))

            // Action buttons
            HStack {
                goToStartButton
                goToEndButton
            }
        }
    }

    private var goToStartButton: some View {
        Button {
            onGoToStart()
        } label: {
            Image(systemName: PlayerIcons.BookmarkPanel.startOfBookmark)
                .font(.title)
                .clipShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var goToEndButton: some View {
        Button {
            onGoToEnd()
        } label: {
            Image(systemName: PlayerIcons.BookmarkPanel.endOfBookmark)
                .font(.title)
                .clipShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var editButton: some View {
        Button(action: onEditTapped) {
            Text("Edit")
                .bold()
        }
        .buttonStyle(PlainButtonStyle())
    }

}
