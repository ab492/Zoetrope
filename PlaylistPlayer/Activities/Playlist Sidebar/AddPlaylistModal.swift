//
//  AddPlaylistModal.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 28/02/2021.
//

import SwiftUI

struct AddPlaylistModal: View {

    // MARK: - State and Properties

    @Environment(\.presentationMode) var presentationMode
    @State private var text = ""

    var onCreate: (String) -> Void

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Text("Enter a name for your playlist.")
                VStack(spacing: 0) {
                    CustomTextField(text: $text, isFirstResponder: true)
                        .frame(height: 50)
                    underlineView
                }
            }
            .navigationBarTitle(Text("New Playlist"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelNavigationItem
                doneNavigationItem
            }
        }

    }

    // MARK: - Private

    private var underlineView: some View {
        Rectangle()
            .frame(height: 1)
            .padding(.horizontal, 40)
            .foregroundColor(.accentColor)
    }

    private var doneNavigationItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                presentationMode.wrappedValue.dismiss()

                onCreate(text.trimmingCharacters(in: .whitespaces))
            } label: {
                Text("Create")
            }
            .disabled(isCreateButtonDisabled)
        }
    }

    private var cancelNavigationItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
            }
        }
    }

    private var isCreateButtonDisabled: Bool {
        text == ""
    }
}
