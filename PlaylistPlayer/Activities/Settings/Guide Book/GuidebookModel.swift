//
//  GuidebookModel.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 26/03/2021.
//

import Foundation

struct GuidebookModel: Codable {

    // MARK: - Types

    struct GuidebookSection: Identifiable, Codable {
        let id: UUID
        let title: String
        let subtitle: String
        let tips: [Tip]

        var formattedTipCount: String {
            "\(tips.count) tips"
        }

        init(id: UUID = UUID(), title: String, subtitle: String, tips: [GuidebookModel.Tip]) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.tips = tips
        }
    }

    struct Tip: Identifiable, Codable {
        let id: UUID
        let preHeading: String?
        let heading: String
        let body: String
        let image: String?

        init(id: UUID = UUID(), preHeading: String? = nil, heading: String, body: String, image: String? = nil) {
            self.id = id
            self.preHeading = preHeading
            self.heading = heading
            self.body = body
            self.image = image
        }
    }

    // MARK: - Properties

    let sections: [GuidebookSection]
}

struct GettingStartedGuide {
    static private let addingMediaTip = GuidebookModel.Tip(heading: "Adding media",
                                                           body: "Add media to your playlist from your files. You can add local media, media from your preferred cloud service or a server on your local network.",
                                                           image: "Example")
    static private let sortMediaTip = GuidebookModel.Tip(heading: "Reordering media",
                                                         body: "Prepare your playlist by ordering your media.",
                                                         image: "Example")

    static let section = GuidebookModel.GuidebookSection(title: "Getting started",
                                                         subtitle: "How to get up and running",
                                                         tips: [addingMediaTip, sortMediaTip])
}
