//
//  CameraError.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

public enum CameraError: Error, Sendable {
    case notAvailable
    case unableToAddInput
    case unableToAddOutput
}
