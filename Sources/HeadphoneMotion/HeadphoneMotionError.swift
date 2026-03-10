//
//  HeadphoneMotionError.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/16.
//

import CoreMotion

/// Errors that can occur when starting headphone motion updates.
public enum HeadphoneMotionError: Error, Sendable {
    /// The device does not support headphone motion.
    case notAvailable
    /// The app is not authorized to access headphone motion data.
    ///
    /// - Parameter status: The current authorization status.
    case notAuthorized(CMAuthorizationStatus)
}
