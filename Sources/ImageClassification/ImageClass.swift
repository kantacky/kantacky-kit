//
//  ImageClass.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import Vision

/// A classification result containing the predicted label and its confidence score.
public struct ImageClass: Sendable {
    /// The classification label identifier (e.g., `"cat"`, `"dog"`).
    public let identifier: String
    /// The confidence score of the classification, ranging from 0.0 to 1.0.
    public let confidence: VNConfidence

    /// Creates a new image classification result.
    ///
    /// - Parameters:
    ///   - identifier: The classification label identifier.
    ///   - confidence: The confidence score of the classification.
    public init(identifier: String, confidence: VNConfidence) {
        self.identifier = identifier
        self.confidence = confidence
    }
}
