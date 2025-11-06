//
//  CameraViewModel.swift
//  LiveCapture
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import AVFoundation
import Camera
import CoreImage
import Observation

@Observable
final class CameraViewModel {
    private(set) var ciImage: CIImage?

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
            for await ciImage in try await CameraManager().ciImageUpdates(queue: queue) {
                self.ciImage = ciImage
            }
        } catch {
            print(error)
        }
    }
}
