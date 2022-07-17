//
//  GuidebookListRow.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/03/2021.
//

import SwiftUI

struct GuidebookListRow: View {
//    let image: Image
    let title: String
    let subtitle: String
    let secondaryInfoText: String

    var body: some View {
        HStack(spacing: 10) {
        Image("iPhone")
            .background(Color(white: 0.7).opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .bold()
                Text(subtitle)
                Text(secondaryInfoText)
                    .foregroundColor(.secondary)
            }
        }

    }
}
