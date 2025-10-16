//
//  HeadphoneMotionError.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/16.
//

import CoreMotion

public enum HeadphoneMotionError: Error, Sendable {
    case notAvailable
    case notAuthorized(CMAuthorizationStatus)
}
