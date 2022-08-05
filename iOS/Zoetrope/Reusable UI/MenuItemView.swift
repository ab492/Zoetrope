//
//  MenuItemView.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 07/03/2021.
//

import SwiftUI

struct MenuItemView: View {

    var title: String
    var iconSystemName: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: iconSystemName)
        }
    }
}
