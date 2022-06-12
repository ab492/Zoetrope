//
//  Video.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 01/02/2021.
//

import Foundation

final class Video: Identifiable, Codable {

    // MARK: - Properties

    let id: UUID
    let filename: String

    /// The approximate duration for the video (in seconds, rather that as `MediaTime`).
    let duration: Time
    var thumbnailFilename: String?
    var url: URL
    private var bookmarkData: Data?
    private var isSecurityScoped = false
    
    // MARK: - Init

    init(id: UUID = UUID(), url: URL, filename: String, duration: Time, thumbnailFilename: String? = nil) {
        self.id = id
        self.filename = filename
        self.duration = duration
        self.thumbnailFilename = thumbnailFilename
        self.url = url

        isSecurityScoped = url.startAccessingSecurityScopedResource()
        self.bookmarkData = try? url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case filename
        case duration
        case thumbnailFilename
        case url
        case bookmarkData
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        filename = try values.decode(String.self, forKey: .filename)
        duration = try values.decode(Time.self, forKey: .duration)
        thumbnailFilename = try? values.decode(String.self, forKey: .thumbnailFilename)

        var isStale = false
        bookmarkData = try? values.decode(Data.self, forKey: .bookmarkData)

        if let data = bookmarkData {
            // Don't think we use isStale flag as we generate bookmark data each save anyway.
            url = try URL(resolvingBookmarkData: data, options: .withoutUI, relativeTo: nil, bookmarkDataIsStale: &isStale)
            isSecurityScoped = url.startAccessingSecurityScopedResource()
        } else {
            url = try values.decode(URL.self, forKey: .url)
        }
    }

    enum VideoError: Error {
        case unableToResolveBookmark
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(filename, forKey: .filename)
        try container.encode(duration, forKey: .duration)
        try container.encode(thumbnailFilename, forKey: .thumbnailFilename)
        try container.encode(url, forKey: .url)

        bookmarkData = try url.bookmarkData(options: .suitableForBookmarkFile,
                                            includingResourceValuesForKeys: nil, relativeTo: nil)
        try container.encode(bookmarkData, forKey: .bookmarkData)
    }

    deinit {
        url.stopAccessingSecurityScopedResource()
    }
}

extension Video: Equatable {
    // TODO: Update this equatable conformance!!
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id && lhs.filename == rhs.filename && lhs.thumbnailFilename == rhs.thumbnailFilename
    }
}
