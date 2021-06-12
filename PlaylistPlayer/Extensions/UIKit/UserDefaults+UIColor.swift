//
//  UserDefaults+UIColor.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 30/04/2021.
//

import Foundation
import UIKit

extension UserDefaults {

    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }

    func set(_ value: UIColor, forKey key: String) {

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
    }

}
