//
//  BookmarkTimecodeSetterView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 21/03/2021.
//

import SwiftUI

struct BookmarkTimecodeSetterView: View {

    let actionTitle: String
    let timecodeTitle: String
    let onTap: () -> Void

    var body: some View {
        VStack {
            Text(timecodeTitle)
            Button {
                onTap()
            } label: {
                Text(actionTitle)
            }
        }
    }
}

struct BookmarkTimecodeSetterView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkTimecodeSetterView(actionTitle: "Set Start",
                                   timecodeTitle: "00:02:34:32",
                                   onTap: { })
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
