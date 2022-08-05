//
//  SettingsView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 12/04/2021.
//

import SwiftUI
import MessageUI

struct SettingsView: View {

    @Environment(\.showingSheet) var showingSheet
    @State var isShowingMailView = false

    var body: some View {
        NavigationView {
            Form {
                if MFMailComposeViewController.canSendMail() {
                    Section(header: Text("Feedback")) {
                        Button {
                            self.isShowingMailView.toggle()
                        } label: {
                            Text("Send Feedback")
                        }.accentColor(.white)
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        self.showingSheet?.wrappedValue = false
                    }
                }
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView, recipients: ["lectern_yon.0y@icloud.com"], subject: "Zoetrope Feedback")
            }
        }
    }
}

struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}
