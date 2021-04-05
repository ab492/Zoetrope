//
//  BookmarkListViewView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 21/03/2021.
//

import SwiftUI

struct BookmarkListView: View {

    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @State var selectedBookmark: Video.Bookmark?
    @State private var presentEditMode = false
    
    var body: some View {
        NavigationView {
            if presentEditMode,
               let selectedBookmark = selectedBookmark {
                EditBookmarkView(viewModel: viewModel.editBookmarkViewModel(for: selectedBookmark), isPresenting: $presentEditMode)
            } else {
                bookmarkList
            }
        }
    }

    private var bookmarkList: some View {
        List {
            ForEach(viewModel.bookmarks) { bookmark in
                HStack(alignment: .center) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(viewModel.currentBookmarks.contains(bookmark) ? .green : .clear)
                    BookmarkListRow(timeIn: viewModel.formattedTimeInForBookmark(bookmark) ,
                                    timeOut: viewModel.formattedTimeOutForBookmark(bookmark),
                                    note: bookmark.note ?? "No note",
                                    onEditTapped: {
                                        selectedBookmark = bookmark
                                        presentEditMode.toggle()
                                    },
                                    onGoToStart: { viewModel.goToStartOfBookmark(bookmark) },
                                    onGoToEnd: { viewModel.goToEndOfBookmark(bookmark) })
//                        NavigationLink(destination: EditBookmarkView(viewModel: viewModel.editBookmarkViewModel(for: bookmark),
//                                                                     isPresenting: $presentEditMode), label: {
//                                                                        Text("Edit")
//                                                                            .background(Color.red)
//                                                                     })

//                        NavigationLink(destination: EditBookmarkView(viewModel: viewModel.editBookmarkViewModel(for: bookmark),
//                                                                     isPresenting: $presentEditMode),
//                                       isActive: $presentEditMode, label: {
//                                        Text("Edit")
//                                            .background(Color.red)
//                                       })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .onDelete(perform: removeRows)
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            leadingToolbar
            trailingToolbar
        }
    }

    private func removeRows(at offsets: IndexSet) {
        viewModel.remove(bookmarksAt: offsets)
    }

    private var trailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            previousButton
            nextButton
        }
    }

    private var leadingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            addButton
        }
    }

    private var addButton: some View {
        Button {
            withAnimation {
                viewModel.addBookmark()
            }
        } label: {
            Image(systemName: "plus")
                .clipShape(Rectangle())
        }
    }

    private var previousButton: some View {
        Button {
            viewModel.previousBookmark()
        } label: {
            Image(systemName: PlayerIcons.BookmarkPanel.previousBookmark)
                .clipShape(Rectangle())
        }
    }

    private var nextButton: some View {
        Button {
            viewModel.nextBookmark()
        } label: {
            Image(systemName: PlayerIcons.BookmarkPanel.nextBookmark)
                .clipShape(Rectangle())
        }
    }
}
