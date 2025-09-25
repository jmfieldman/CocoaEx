//
//  UIViewController+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import UIKit

public extension UIViewController {
    /// Recursively searches for the most descendent view controller
    /// that is being presented from the receiver. Call this on the
    /// ancestor.
    var presentedDescendent: UIViewController? {
        if let child = presentedViewController {
            return child.presentedDescendent ?? child
        }

        if let navigationController = self as? UINavigationController {
            for controller in navigationController.viewControllers.reversed() {
                if let descendent = controller.presentedViewController {
                    return descendent.presentedDescendent ?? descendent
                }
            }
        }

        if let tabController = self as? UITabBarController {
            for controller in tabController.viewControllers ?? [] {
                if let descendent = controller.presentedViewController {
                    return descendent.presentedDescendent ?? descendent
                }
            }
        }

        for child in children {
            if let descendent = child.presentedViewController {
                return descendent.presentedDescendent ?? descendent
            }
        }

        return nil
    }

    /// Similar to the standard `present(_:animated:)` except that it
    /// uses `presentedDescendent` to ensure that the present call is
    /// being made on the most-visible descendent view controller.
    func deepPresent(_ viewController: UIViewController, animated: Bool) {
        (presentedDescendent ?? self).present(viewController, animated: animated)
    }

    /// Remove ambiguity in dismiss function calling, and explicitly
    /// allow calling dismiss on the presentingViewController, where
    /// action is only taken if it is actively presenting another
    /// controller.
    func dismissToSelf(animated: Bool, completion: (() -> Void)? = nil) {
        if let presentedViewController {
            presentedViewController.dismiss(animated: animated, completion: completion)
        }
    }
}
