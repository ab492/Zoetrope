//
//  StaticDrawingOverlay.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 14/04/2021.
//

import SwiftUI
import PencilKit

struct StaticDrawingOverlay: View {

    @StateObject var viewModel: DrawingModeViewModel
    @State var toolPicker = PKToolPicker()

    var body: some View {
        if let image = viewModel.drawingImageRepresentation {
            Image(uiImage: image)
        } else {
            Color.pink.opacity(0.3)
        }
    }
}
