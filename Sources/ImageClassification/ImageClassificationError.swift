//
//  ImageClassificationError.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

/// Errors that can occur during image classification.
public enum ImageClassificationError: Error, Sendable {
    /// The classification request did not return valid `VNClassificationObservation` results.
    case classificationResultsNotFound
}
