//
//  Video+Models.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/03/2021.
//

import Foundation

extension Video {

    final class Bookmark: NSObject, Codable, Identifiable {
        var id: UUID
        private(set) var timeIn: MediaTime
        private(set) var timeOut: MediaTime
        var note: String?
        var drawing: Data?

        init(id: UUID, timeIn: MediaTime, timeOut: MediaTime, note: String? = nil, drawing: Data? = nil) {
            let constrainedTimeIn = timeIn.constrained(min: MediaTime(seconds: 0))
            let constrainedTimeOut = timeOut.constrained(min: constrainedTimeIn)

            self.id = id
            self.timeIn = constrainedTimeIn
            self.timeOut = constrainedTimeOut
            self.note = note
            self.drawing = drawing
        }

        func setTimeIn(_ timeIn: MediaTime) {
            // Don't let time in be greater than the time out.
            self.timeIn = timeIn.constrained(max: timeOut)
        }

        func setTimeOut(_ timeOut: MediaTime) {
            // Don't let time out be less than time in.
            self.timeOut = timeOut.constrained(min: timeIn)
        }
    }
}

// MARK: - NSCopying

extension Video.Bookmark: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        Video.Bookmark(id: id, timeIn: timeIn, timeOut: timeOut, note: note, drawing: drawing)
    }
}
