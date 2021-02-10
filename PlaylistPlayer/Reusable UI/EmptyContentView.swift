//
//  EmptyContentView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/02/2021.
//

import SwiftUI

/// A view to display to indicate emptiness (no content).
struct EmptyContentView: View {

    let text: String

    var body: some View {
        Text(text)
    }
}
