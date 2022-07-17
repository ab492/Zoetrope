//
//  GuideBookListView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/03/2021.
//

import SwiftUI

struct GuidebookListView: View {

    private let model = Bundle.main.decode(GuidebookModel.self, from: "Guidebook.json")
    
    var body: some View {
        List {
            ForEach(model.sections, id: \.id) { section in
                NavigationLink(destination: GuidebookDetailView(tips: section.tips)) {
                    GuidebookListRow(title: section.title,
                                     subtitle: section.subtitle,
                                     secondaryInfoText: section.formattedTipCount)
                }
//                .listRowBackground(Color("Background"))
            }
        }
        .listStyle(GroupedListStyle())
        .onAppear { convertModelToJson() }
    }

    func convertModelToJson() {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)

        let defaultLocation = FileManager.default.documentsDirectory
            .appendingPathComponent("Guidebook")
            .appendingPathExtension("json")

        try! jsonData.write(to: defaultLocation)
    }
}
