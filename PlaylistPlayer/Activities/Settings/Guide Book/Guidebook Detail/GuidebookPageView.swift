//
//  GuidebookPageView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/03/2021.
//

import SwiftUI

struct GuidebookPageView: View {
    let preHeading: String?
    let heading: String
    let tipText: String
    let imageName: String?

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Image(imageName ?? "Example") // TODO: Sort out this optional!
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, alignment: .center)
                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        if let preHeading = preHeading {
                            Text(preHeading)
                                .font(.subheadline)
                                .textCase(.uppercase)
                                .foregroundColor(.secondary)
                        }

                        Text(heading)
                            .font(.title)

                        Text(tipText)
                    }
                    .padding([.top, .horizontal])
                    .offset(x: geo.frame(in: .global).minX / 5)
                    .background(Color.red)
                }
            }
        }
    }
}
