//
//  Time.swift
//  QFS
//
//  Created by Andy Brown on 09/06/2020.
//  Copyright © 2020 Andy Brown. All rights reserved.
//

import Foundation

struct Time {

    private let timeInSeconds: Double

    init(seconds: Double) {
        self.timeInSeconds = seconds

    }

    var seconds: Double {
        return timeInSeconds
    }
}
