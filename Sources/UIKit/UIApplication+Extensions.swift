//
//  UIApplication+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

#if os(iOS)

import UIKit

public extension UIApplication {
    /// Sends the UIResponder.resignFirstResponder to the first responder in the UIApplication.
    func resignAnyFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#endif
