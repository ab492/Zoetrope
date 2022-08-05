//
//  AccessibilityService.swift
//  Zoetrope
//
//  Created by Andy Brown on 30/07/2022.
//

import Combine
import UIKit

protocol AccessibilityService {
    var isVoiceoverEnabled: Bool { get }
}

final class AccessibilityServiceImpl: AccessibilityService {
    var isVoiceoverEnabled: Bool {
        UIAccessibility.isVoiceOverRunning
    }
}

