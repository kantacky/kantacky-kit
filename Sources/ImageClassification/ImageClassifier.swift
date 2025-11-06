//
//  ImageClassifier.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import CoreML
import Vision

public final actor ImageClassifier {
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
