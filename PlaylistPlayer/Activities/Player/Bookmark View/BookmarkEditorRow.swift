//
//  BookmarkEditorRow.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 20/03/2021.
//

import SwiftUI

struct BookmarkEditorRow: View {
    let timeIn: String
    let timeOut: String
    let goToStart: () -> Void
    let onSetStart: () -> Void
    let onSetEnd: () -> Void
    let goToEnd: () -> Void

    var body: some View {
        HStack {
            goToStartButton
            BookmarkTimecodeSetterView(actionTitle: "Set Start",
                                       timecodeTitle: timeIn,
                                       onTap: onSetStart)
            Spacer()
            BookmarkTimecodeSetterView(actionTitle: "Set End",
                                       timecodeTitle: timeOut,
                                       onTap: onSetEnd)
            goToEndButton
        }
    }

    private var goToStartButton: some View {
        Button {
            goToStart()
        } label: {
            Image(systemName: "chevron.forward")
        }
    }

    private var goToEndButton: some View {
        Button {
            goToEnd()
        } label: {
            Image(systemName: "chevron.backward")
        }
    }
}

struct BookmarkEditorRow_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkEditorRow(timeIn: "Time In",
                          timeOut: "Time Out",
                          goToStart: { },
                          onSetStart: { },
                          onSetEnd: { },
                          goToEnd: { })
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
