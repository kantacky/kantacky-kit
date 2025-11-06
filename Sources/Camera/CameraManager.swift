//
//  CameraManager.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

import AVFoundation
import CoreImage

public final class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session: AVCaptureSession
    private let (_ciImageUpdates, ciImageContinuation): (AsyncStream<CIImage>, AsyncStream<CIImage>.Continuation)

    public override init() {
        session = .init()
        (_ciImageUpdates, ciImageContinuation) = AsyncStream<CIImage>.makeStream()
        super.init()
    }

    public func ciImageUpdates(queue: dispatch_queue_t? = .main) async throws -> AsyncStream<CIImage> {
        try configureCaptureSession(queue: queue)
        session.startRunning()
        return _ciImageUpdates
    }

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        ciImageContinuation.yield(ciImage)
    }

    private func configureCaptureSession(queue: dispatch_queue_t?) throws {
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        defer { session.commitConfiguration() }

        // Setup Device
        guard
            let device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .back
            ).devices.first
        else {
            throw CameraError.notAvailable
        }

        // Setup Input
        let input = try AVCaptureDeviceInput(device: device)
        guard session.canAddInput(input) else {
            throw CameraError.unableToAddInput
        }
        session.addInput(input)

        // Setup Output
        let output = AVCaptureVideoDataOutput()
        guard session.canAddOutput(output) else {
            throw CameraError.unableToAddOutput
        }
        session.addOutput(output)

        output.alwaysDiscardsLateVideoFrames = true
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        output.setSampleBufferDelegate(self, queue: queue)
        output.connection(with: .video)?.isEnabled = true
    }
}
