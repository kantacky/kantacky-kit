//
//  ImageClassProtocol.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import Vision

public protocol ImageClassProtocol: RawRepresentable<String>, Sendable {
    static var defaultValue: Self { get }

    var confidence: VNConfidence { get }

    init(rawValue: String, confidence: VNConfidence)
}
