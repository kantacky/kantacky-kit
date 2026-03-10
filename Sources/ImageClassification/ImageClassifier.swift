//
//  ImageClassifier.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import CoreML
import Vision

/// An actor that performs image classification using a Core ML model via the Vision framework.
public final actor ImageClassifier {
    /// Classifies an image using the specified Core ML model.
    ///
    /// The image is center-cropped before classification. The method returns the top prediction,
    /// or `nil` if no classifications are found.
    ///
    /// - Parameters:
    ///   - model: The `VNCoreMLModel` to use for classification.
    ///   - cgImage: The image to classify.
    ///   - orientation: The orientation of the image.
    /// - Returns: The top ``ImageClass`` prediction, or `nil` if no results are available.
    /// - Throws: ``ImageClassificationError/classificationResultsNotFound`` if the results cannot be parsed,
    ///   or any error from the Vision framework.
    public static func predict(
        with model: VNCoreMLModel,
        for cgImage: CGImage,
        orientation: CGImagePropertyOrientation
    ) async throws -> ImageClass? {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let observations = request.results as? [VNClassificationObservation] else {
                    continuation.resume(throwing: ImageClassificationError.classificationResultsNotFound)
                    return
                }
                let predictions = observations.map { observation in
                    ImageClass(
                        identifier: observation.identifier,
                        confidence: observation.confidence
                    )
                }
                continuation.resume(returning: predictions.first)
            }

            request.imageCropAndScaleOption = .centerCrop

            do {
                try VNImageRequestHandler(
                    cgImage: cgImage,
                    orientation: orientation
                )
                .perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
