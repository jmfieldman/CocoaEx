//
//  UIView+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import UIKit

public extension UIView {
    func firstAncestor<T: UIView>(ofKind kind: T.Type) -> T? {
        guard let superview else {
            return nil
        }

        if let needle = superview as? T {
            return needle
        }

        return superview.firstAncestor(ofKind: kind)
    }
}
