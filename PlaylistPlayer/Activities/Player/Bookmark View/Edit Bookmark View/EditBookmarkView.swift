//
//  BoomarkEditorView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 01/04/2021.
//

import SwiftUI

struct EditBookmarkView: View {

    // MARK: - State

    @StateObject var viewModel: ViewModel
    @Binding var isPresenting: Bool

    // MARK: - Init

    init(viewModel: ViewModel, isPresenting: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isPresenting = isPresenting

        UITextView.appearance().backgroundColor = .clear
    }

    // MARK: - View

    var body: some View {
        List {
            Section {
                noteTextEditor
            }
            Section {
                SetInOutView(title: "Set Start", timecodeLabel: viewModel.timeInLabel) { viewModel.setTimeIn() }
                SetInOutView(title: "Set End", timecodeLabel: viewModel.timeOutLabel) { viewModel.setTimeOut() }
            }
        }
        .navigationBarTitle("Edit Bookmark")
        .listStyle(GroupedListStyle())
        .toolbar {
            leadingToolbar
            trailingToolbar
        }
        .onDisappear(perform: viewModel.save)
    }

    private var noteTextEditor: some View {
        ZStack {
            // This adds a placeholder to the `TextEditor`.
            // https://stackoverflow.com/questions/62741851/how-to-add-placeholder-text-to-texteditor-in-swiftui
            if viewModel.noteIsEmpty {
                HStack {
                    Text("Add a note")
                        .italic()
                        .foregroundColor(.secondary)
                        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 10))
                    Spacer()
                }
            }

            // This makes sure the `TextEditor` is correctly sized over multiple lines.
            // https://stackoverflow.com/questions/62620613/dynamic-row-hight-containing-texteditor-inside-a-list-in-swiftui
            TextEditor(text: $viewModel.note ?? "")
                .padding(.all, 0)
//                .background(Color.red)
            Text(viewModel.note ?? "")
                .opacity(0)
                .padding(.all, 10)
//                .padding(.all, 8)
        }
    }

    // MARK: - Toolbar

    private var trailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            saveButton
        }
    }

    private var leadingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            resetButton
        }
    }

    private var saveButton: some View {
        Button {
//            viewModel.save()
            isPresenting.toggle()
        } label: {
            Text("Done")
        }
//        .disabled(viewModel.changesMade ? false : true)
    }

    private var resetButton: some View {
        Button {
            viewModel.reset()
        } label: {
            Text("Reset")
        }
        .disabled(viewModel.changesMade ? false : true)
    }
}

extension EditBookmarkView {
    struct SetInOutView: View {

        let title: String
        let timecodeLabel: String
        let onTap: () -> Void

        var body: some View {
            Button {
                onTap()
            } label: {
                HStack {
                    Text(title)
                    Spacer()
                    Text(timecodeLabel)
                }
                .foregroundColor(.primary)
            }
        }
    }
}

