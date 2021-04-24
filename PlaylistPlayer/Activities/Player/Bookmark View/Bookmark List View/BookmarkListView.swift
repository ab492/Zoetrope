//
//  BookmarkListViewView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 21/03/2021.
//

import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct BookmarkListView: View {

    // MARK: - State Properties

    @StateObject var viewModel: ViewModel
    @State var selectedBookmark: Video.Bookmark?
    @State private var presentEditMode = false

    // MARK: - Init

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - View

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
                Button {
                    selectedBookmark = bookmark
                    presentEditMode.toggle()
                } label: {
                    BookmarkListRow(timeLabel: viewModel.formattedTimeForBookmark(bookmark),
                                    note: viewModel.formattedNoteForBookmark(bookmark),
                                    isCurrent: viewModel.currentBookmarks.contains(bookmark),
                                    isLooping: viewModel.bookmarkOnLoop == bookmark,
                                    hasDrawings: bookmark.hasDrawing,
                                    onEditTapped: {
                                        // TODO: Remove this!
                                        selectedBookmark = bookmark
                                        presentEditMode.toggle()
                                    },
                                    onGoToStart: { viewModel.goToStartOfBookmark(bookmark) },
                                    onGoToEnd: { viewModel.goToEndOfBookmark(bookmark) },
                                    onLoopTapped: { toggleLoopMode(for: bookmark) })
                }
            }
            .onDelete(perform: removeRows)
            .listRowBackground(Color.secondarySystemGroupedBackground)
        }
        .background(Color.secondarySystemBackground)
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            leadingToolbar
            trailingToolbar
        }
        .onAppear { UINavigationBar.appearance().backgroundColor = .secondarySystemGroupedBackground }
        .onDisappear(perform: viewModel.save)
    }

    // MARK: - Toolbar

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
            Image(systemName: PlayerIcons.BookmarkPanel.addBookmark)
                .clipShape(Rectangle())
        }
    }

    private var previousButton: some View {
        Button(action: viewModel.previousBookmark) {
            Image(systemName: PlayerIcons.BookmarkPanel.previousBookmark)
                .clipShape(Rectangle())
        }
    }

    private var nextButton: some View {
        Button(action: viewModel.nextBookmark) {
            Image(systemName: PlayerIcons.BookmarkPanel.nextBookmark)
                .clipShape(Rectangle())
        }
    }

    // MARK: - Helpers

    private func removeRows(at offsets: IndexSet) {
        viewModel.remove(bookmarksAt: offsets)
    }

    private func toggleLoopMode(for bookmark: Video.Bookmark) {
        if viewModel.bookmarkOnLoop == bookmark {
            viewModel.bookmarkOnLoop = nil
        } else {
            viewModel.bookmarkOnLoop = bookmark
        }
    }
}
