//
//  ImageClass.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import Vision

public struct ImageClass: Sendable {
    public let identifier: String
    public let confidence: VNConfidence

    public init(identifier: String, confidence: VNConfidence) {
        self.identifier = identifier
        self.confidence = confidence
    }
}
