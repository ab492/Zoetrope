//
//  BookmarkListRow.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 20/03/2021.
//

import SwiftUI

struct BookmarkListRow: View {

    // MARK: - Properties

    let timeLabel: String
    let note: String
    let isCurrent: Bool
    let isLooping: Bool
    let hasDrawings: Bool
    let onEditTapped: () -> Void
    let onGoToStart: () -> Void
    let onGoToEnd: () -> Void
    let onLoopTapped: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            timeInfoAndNotesVStack
            Spacer(minLength: 0)
            optionsMenu
        }
    }

    // MARK: - Information and Note Views

    private var timeInfoAndNotesVStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            secondaryInformationHStack
            noteHStack
        }
    }

    private var secondaryInformationHStack: some View {
        HStack(alignment: .center) {
            isCurrentCircularIndicator
                .foregroundColor(isCurrent ? .green : .clear)
            timeLabels
            maybeHasDrawingsIndicator
            maybeIsLoopingIndicator
        }
    }

    private var noteHStack: some View {
        HStack {
            isCurrentCircularIndicator
                .foregroundColor(.clear) // Added as clear to match the spacing with the green indicator above.

            Text(note)
                .font(.system(size: 15, weight: .regular, design: .default))
        }
    }

    private var timeLabels: some View {
        Text(timeLabel)
            .font(.system(size: 17, weight: .regular, design: .default))
            .foregroundColor(.secondary)
    }

    private var isCurrentCircularIndicator: some View {
        Circle()
            .frame(width: 10, height: 10)
    }

    @ViewBuilder
    private var maybeIsLoopingIndicator: some View {
        if isLooping {
            Image(systemName: PlayerIcons.BookmarkPanel.loopBookmark)
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundColor(.tertiarySystemBackground)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private var maybeHasDrawingsIndicator: some View {
        if hasDrawings {
            Image(systemName: PlayerIcons.BookmarkPanel.bookmarkHasDrawings)
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundColor(.tertiarySystemBackground)
        } else {
            EmptyView()
        }
    }

    // MARK: - Options Menu

    private var optionsMenu: some View {
        Menu {
            editButton
            loopButton
            goToFirstFrameButton
            goToLastFrameButton
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title2)
                .frame(width: 44, height: 44)
        }
    }

    private var editButton: some View {
        Button(action: onEditTapped) {
            Label("Edit Bookmark", systemImage: "note.text")
        }
    }

    private var loopButton: some View {
        Button(action: onLoopTapped) {
            Label(isLooping ? "Unloop Bookmark" : "Loop Bookmark", systemImage: PlayerIcons.BookmarkPanel.loopBookmark)
        }
    }

    private var goToFirstFrameButton: some View {
        Button(action: onGoToStart) {
            Label("Go to First Frame", systemImage: PlayerIcons.BookmarkPanel.startOfBookmark)
        }
    }

    private var goToLastFrameButton: some View {
        Button(action: onGoToEnd) {
            Label("Go to Last Frame", systemImage: PlayerIcons.BookmarkPanel.endOfBookmark)
        }
    }
}
