//
//  UIColor+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import UIKit

public extension UIColor {
    /// Generate a UIColor that adapts to the light/dark state of the app
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }

    convenience init(displayP3Red: Int, green: Int, blue: Int, alpha: Int = 0xFF) {
        self.init(
            displayP3Red: CGFloat(displayP3Red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }

    convenience init(rgb: Int) {
        self.init(
            displayP3Red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: 0xFF
        )
    }

    convenience init(argb: Int) {
        self.init(
            displayP3Red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            alpha: (argb >> 24) & 0xFF
        )
    }
}
