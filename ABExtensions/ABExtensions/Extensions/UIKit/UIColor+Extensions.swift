//
//  UIColor+Extensions.swift
//  ABExtensions
//
//  Created by Andy Brown on 03/07/2021.
//

import UIKit

public extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
}
