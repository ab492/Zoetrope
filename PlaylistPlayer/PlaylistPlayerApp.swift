//
//  PlaylistPlayerApp.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 23/01/2021.
//

import SwiftUI
import AVFoundation

@main
struct PlaylistPlayerApp: App {

    // MARK: - State

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase

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
        let window = UIApplication.shared.windows.first
        window?.overrideUserInterfaceStyle = .dark
        window?.tintColor = UIColor(Color.red)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        WorldConfigurer.buildWorld()
        
        // TODO: Move this somewhere more appropriate in line with playback.
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        fatalError("DID RECEIVE MEMORY WARNING!")
    }
}
