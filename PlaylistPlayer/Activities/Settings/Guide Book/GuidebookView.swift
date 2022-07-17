//
//  GuidebookView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/03/2021.
//

import SwiftUI

struct GuidebookView: View {
    @Environment(\.showingSheet) var showingSheet
    
    var body: some View {
        GuidebookListView()
            .navigationTitle("Guide")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        self.showingSheet?.wrappedValue = false
                        
                    }
                }
            }
            .onAppear {
                //                    UITableView.appearance().backgroundColor = UIColor(named: "Background")
                UIPageControl.appearance().currentPageIndicatorTintColor = .label
            }
    }
}
