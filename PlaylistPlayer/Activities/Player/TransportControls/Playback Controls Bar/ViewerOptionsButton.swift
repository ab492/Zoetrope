//
//  ViewerOptionsButtons.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 18/03/2021.
//

import SwiftUI

struct ViewerOptionsButton: View {
    var systemImage: String
    var isSelected: Bool
    var onTap: () -> Void

//    init(systemImage: String, isSelected: Bool) {
//        self.systemImage = systemImage
//        _isSelected = isSelected
//    }

    var body: some View {
        VStack(spacing: 5) {
            Button {
                // TODO: Should the animation live here?
//                withAnimation {
//                    isSelected.toggle()
//                }
                onTap()
            } label: {
                VStack {
                    Image(systemName: systemImage)
                        .font(.title2)
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

//struct ViewerOptionsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewerOptionsButton(systemImage: "scribble.variable",
//                            isSelected: .constant(true))
//            .accentColor(.red)
//            .previewLayout(PreviewLayout.sizeThatFits)
//            .padding()
//            .background(Color.gray)
//            .previewDisplayName("Selected State")
//
//        ViewerOptionsButton(systemImage: "scribble.variable",
//                            isSelected: .constant(true))
//            .accentColor(.red)
//            .previewLayout(PreviewLayout.sizeThatFits)
//            .padding()
//            .background(Color.gray)
//            .previewDisplayName("Unselected State")
//    }
//}
