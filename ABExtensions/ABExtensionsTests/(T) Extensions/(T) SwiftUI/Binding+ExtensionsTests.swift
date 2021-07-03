//
//  Binding+ExtensionsTests.swift
//  ABExtensionsTests
//
//  Created by Andy Brown on 03/07/2021.
//

import XCTest
import SwiftUI

class Binding_ExtensionsTests: XCTestCase {

    func testBindingOnChange() {
        // Given
        var onChangeFunctionRun = false

        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""

        let binding = Binding(
            get : { storedValue },
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunctionToCall)

        // When
        changedBinding.wrappedValue = "Some changed values"

        // Then
        XCTAssertTrue(onChangeFunctionRun, "The onChange() function must be run when the binding is changed.")
    }

}
