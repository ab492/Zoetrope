//
//  ViewerOptionsButtons.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/03/2021.
//

import SwiftUI

struct ViewerOptionsButton: View {
    var systemImage: String
    @Binding var isSelected: Bool

    var body: some View {
        VStack(spacing: 5) {
            Button {
                isSelected.toggle()
            } label: {
                VStack {
                    Image(systemName: systemImage)
                    Circle()
                        .frame(width: 5, height: 5)
                        .opacity(isSelected ? 1 : 0)
                        .foregroundColor(.accentColor)
                }
            }
            .foregroundColor(.white)
        }
    }
}

struct ViewerOptionsButton_Previews: PreviewProvider {
    static var previews: some View {
        ViewerOptionsButton(systemImage: "scribble.variable",
                            isSelected: .constant(true))
            .accentColor(.red)
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .background(Color.gray)
            .previewDisplayName("Selected State")

        ViewerOptionsButton(systemImage: "scribble.variable",
                            isSelected: .constant(true))
            .accentColor(.red)
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .background(Color.gray)
            .previewDisplayName("Unselected State")
    }
}
