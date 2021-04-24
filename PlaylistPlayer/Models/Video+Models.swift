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

        var isOneFrameLong: Bool {
            timeOut.seconds - timeIn.seconds == 0
        }

        var hasDrawing: Bool {
            drawing != nil
        }

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
            if timeIn > timeOut {
                // If new timeIn is greater than timeOut, update both to match the new timeIn.
                self.timeIn = timeIn
                self.timeOut = timeIn
            } else {
                // If not, just update the timeIn.
                self.timeIn = timeIn
            }
        }

        func setTimeOut(_ timeOut: MediaTime) {
            if timeOut < timeIn {
                // If new timeOut is less than timeIn, update both to match the new timeOut.
                self.timeIn = timeOut
                self.timeOut = timeOut
            } else {
                // If not, just update the timeOut.
                self.timeOut = timeOut
            }
        }
    }
}

// MARK: - NSCopying

extension Video.Bookmark: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        Video.Bookmark(id: id, timeIn: timeIn, timeOut: timeOut, note: note, drawing: drawing)
    }
}
