//
//  CameraError.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

/// Errors that can occur during camera capture setup.
public enum CameraError: Error, Sendable {
    /// No suitable camera device was found.
    case notAvailable
    /// The capture input could not be added to the session.
    case unableToAddInput
    /// The capture output could not be added to the session.
    case unableToAddOutput
}
