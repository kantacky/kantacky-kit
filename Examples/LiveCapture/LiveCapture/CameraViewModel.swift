//
//  CameraViewModel.swift
//  LiveCapture
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import AVFoundation
import Camera
import Observation
import SwiftUI

@Observable
final class CameraViewModel {
    private(set) var uiImage: UIImage?

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
                uiImage = UIImage(cgImage: cgImage)
            }
        } catch {
            print(error)
        }
    }
}
