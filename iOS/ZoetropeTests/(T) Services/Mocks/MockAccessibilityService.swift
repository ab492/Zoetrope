//
//  MockAccessibilityService.swift
//  ZoetropeTests
//
//  Created by Andy Brown on 01/08/2022.
//

@testable import Zoetrope

final class MockAccessibilityService: AccessibilityService {
    var isVoiceoverEnabledValueToReturn = false
    var isVoiceoverEnabled: Bool { isVoiceoverEnabledValueToReturn }
}
