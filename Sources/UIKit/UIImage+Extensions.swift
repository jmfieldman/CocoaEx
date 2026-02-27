//
//  UIImage+Extensions.swift
//  Copyright © 2026 Jason Fieldman.
//

#if os(iOS) || os(tvOS)

import UIKit

public extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

#endif
