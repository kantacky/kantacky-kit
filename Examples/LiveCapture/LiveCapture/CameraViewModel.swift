//
//  CameraViewModel.swift
//  LiveCapture
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import AVFoundation
import Camera
import ImageClassification
import Observation
import SwiftUI
import Vision

@Observable
final class CameraViewModel {
    private(set) var uiImage: UIImage?
    private(set) var classifiedVegetable: ImageClass?

    func onAppear() async {
        guard await AVCaptureDevice.requestAccess(for: .video) else {
            print("Camera access denied")
            return
        }
        let queue = DispatchQueue(
            label: "VideoDataOutput",
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .workItem
        )
        do {
            for await cgImage in try await CameraManager().cgImageUpdates(queue: queue) {
                let uiImage = UIImage(cgImage: cgImage)
                self.uiImage = uiImage
                let model = try VNCoreMLModel(for: VegetableClassifier().model)
                classifiedVegetable = try await ImageClassifier.predict(
                    with: model,
                    for: cgImage,
                    orientation: CGImagePropertyOrientation(uiImage.imageOrientation)
                )
            }
        } catch {
            print(error)
        }
    }
}
