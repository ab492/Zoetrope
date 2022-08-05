//
//  CMTime+Codable.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/03/2021.
//

import CoreMedia
import Foundation

extension CMTime: Codable {
    enum CodingKeys: String, CodingKey {
        case value
        case timescale
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(CMTimeValue.self, forKey: .value)
        let timescale = try container.decode(CMTimeScale.self, forKey: .timescale)
        self.init(value: value, timescale: timescale)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(timescale, forKey: .timescale)
    }
}
