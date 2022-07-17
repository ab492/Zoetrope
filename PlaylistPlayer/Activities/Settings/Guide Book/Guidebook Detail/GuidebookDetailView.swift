//
//  GuidebookDetailView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/03/2021.
//

import SwiftUI



struct GuidebookDetailView: View {
    
    @Environment(\.showingSheet) var showingSheet
    
    let tips: [GuidebookModel.Tip]

    var body: some View {
        TabView {
            ForEach(tips, id: \.id) { tip in
                GuidebookPageView(preHeading: tip.preHeading, heading: tip.heading, tipText: tip.body, imageName: tip.image)
            }
        }
        .background(Color.blue)
        .navigationTitle("Essentials")
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    self.showingSheet?.wrappedValue = false
                }
            }
        }
    }
}

