//
//  BookmarkEditorView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 21/03/2021.
//

import SwiftUI

struct BookmarkEditorView: View {

    @StateObject var viewModel: ViewModel

    init(playlistPlayer: PlaylistPlayerViewModel) {
        _viewModel = StateObject(wrappedValue: ViewModel(playlistPlayer: playlistPlayer))
    }

    var body: some View {
        VStack {
            topControlsBar
            List {
                ForEach(viewModel.bookmarks) { bookmark in
                    BookmarkEditorRow(timeIn: viewModel.formattedTimeInForBookmark(bookmark),
                                      timeOut: viewModel.formattedTimeOutForBookmark(bookmark),
                                      goToStart: { viewModel.goToStartOfBookmark(bookmark) },
                                      onSetStart: { viewModel.setStartOfBookmark(bookmark) },
                                      onSetEnd: { viewModel.setEndOfBookmark(bookmark) },
                                      goToEnd: { viewModel.goToEndOfBookmark(bookmark) })
                        .background(viewModel.currentBookmarks.contains(bookmark) ? Color.green : Color.black)
                }
                .buttonStyle(PlainButtonStyle())

            }
        }
    }

    private var topControlsBar: some View {
        HStack {
            addButton
            Spacer()
            previousButton
            nextButton
            Spacer()
        }
    }

    private var addButton: some View {
        Button {
            viewModel.addBookmark()
        } label: {
            Image(systemName: "plus")
                .font(.largeTitle)
                .clipShape(Rectangle())
        }
    }

    private var previousButton: some View {
        Button {
            viewModel.previousBookmark()
        } label: {
            Text("Prev")
        }
    }

    private var nextButton: some View {
        Button {
            viewModel.nextBookmark()
        } label: {
            Text("Next")
        }
    }
}
