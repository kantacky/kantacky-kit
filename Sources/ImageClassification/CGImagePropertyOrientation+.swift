//
//  CGImagePropertyOrientation+.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import CoreImage
#if canImport(UIKit)
import UIKit.UIImage

extension CGImagePropertyOrientation {
    /// Creates a `CGImagePropertyOrientation` from a `UIImage.Orientation` value.
    ///
    /// - Parameter orientation: The `UIImage.Orientation` to convert.
    public init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
#endif
