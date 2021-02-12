//
//  PlaylistPlayerApp.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI

@main
struct PlaylistPlayerApp: App {

    // MARK: - State

    @Environment(\.scenePhase) private var phase

    // MARK: - Properties

    private var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }

    // MARK: - View

    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.red)
                .preferredColorScheme(.dark)
        }
        .onChange(of: phase) { _ in
            setupColorScheme()
        }
    }

    private func setupColorScheme() {
        // We do this via the window so we can access UIKit components too.
        window?.overrideUserInterfaceStyle = .dark
        window?.tintColor = UIColor(Color.red)
    }
}
