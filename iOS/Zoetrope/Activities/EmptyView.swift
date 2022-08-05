//
//  EmptyView.swift
//  Zoetrope
//
//  Created by Andy Brown on 02/08/2022.
//

import SwiftUI

struct EmptyView: View {
    @State var showSidebar: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 10) {
                Text(secondaryTextTitle)
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(.primary)
                Text(secondaryTextSubtitle)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
        }
        UIKitShowSidebar(showSidebar: showSidebar)
            .frame(width: 0,height: 0)
            .onAppear {
                showSidebar = true
            }
            .onDisappear {
                showSidebar = false
            }
    }
    
    private var secondaryTextTitle: String {
        Current.playlistManager.playlists.isEmpty ? "No Playlists" : "No Playlist Selected"
    }

    private var secondaryTextSubtitle: String {
        Current.playlistManager.playlists.isEmpty ? "Please add a playlist to get started." : "Please select a playlist to show details."
    }
}
