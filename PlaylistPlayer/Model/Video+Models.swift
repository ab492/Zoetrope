//
//  Video+Models.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/03/2021.
//

import Foundation

extension Video {

    enum BookmarkType: Equatable {
        case text(String)
        case drawing(Data)
    }

    class Bookmark: Codable, Identifiable, Equatable {
        var id: UUID
        private(set) var timeIn: MediaTime
        private(set) var timeOut: MediaTime
        var noteType: BookmarkType

        init(id: UUID, timeIn: MediaTime, timeOut: MediaTime, noteType: Video.BookmarkType) {
            let constrainedTimeIn = timeIn.constrained(min: MediaTime(seconds: 0))
            let constrainedTimeOut = timeOut.constrained(min: constrainedTimeIn)

            self.id = id
            self.timeIn = constrainedTimeIn
            self.timeOut = constrainedTimeOut
            self.noteType = noteType
        }

        func setTimeIn(_ timeIn: MediaTime) {
            // Don't let time in be greater than the time out.
            self.timeIn = timeIn.constrained(max: timeOut)
        }

        func setTimeOut(_ timeOut: MediaTime) {
            // Don't let time out be less than time in.
            self.timeOut = timeOut.constrained(min: timeIn)
        }

        static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
            lhs.id == rhs.id &&
                lhs.timeIn == rhs.timeIn &&
                lhs.timeOut == rhs.timeOut &&
                lhs.noteType == rhs.noteType
        }
    }
}

// MARK: - NoteType Codable

extension Video.BookmarkType: Codable {
    enum CodingKeys: String, CodingKey {
        case text, drawing
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Try to decode text. If that doesn't work, we catch the error and try to decode
        // drawing data. If that doesn't work, the error will be propagated.
        do {
            let textValue = try container.decode(String.self, forKey: .text)
            self = .text(textValue)
        } catch {
            let drawingValue = try container.decode(Data.self, forKey: .drawing)
            self = .drawing(drawingValue)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let value):
            try container.encode(value, forKey: .text)
        case .drawing(let value):
            try container.encode(value, forKey: .drawing)
        }
    }
}

