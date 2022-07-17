//
//  SettingsView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 12/04/2021.
//

import SwiftUI

struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}

struct SettingsView: View {

    @Environment(\.showingSheet) var showingSheet

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: GuidebookView()) {
                    Text("User Guide")
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        self.showingSheet?.wrappedValue = false
                    }
                }
            }
        }
    }
}
