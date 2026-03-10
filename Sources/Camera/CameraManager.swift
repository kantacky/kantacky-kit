//
//  CameraManager.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/11/06.
//

@preconcurrency import AVFoundation
import CoreImage

/// A manager that captures video frames from the device camera and delivers them as `CGImage` via an `AsyncStream`.
///
/// `CameraManager` uses `AVCaptureSession` to capture video from the back-facing wide-angle camera
/// and converts each frame to a `CGImage`.
///
/// ```swift
/// let manager = CameraManager()
/// for await image in try await manager.cgImageUpdates() {
///     // Process each captured frame
/// }
/// ```
public final class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, Sendable {
    private let session: AVCaptureSession
    private let ciContext: CIContext
    private let (_cgImageUpdates, cgImageContinuation): (AsyncStream<CGImage>, AsyncStream<CGImage>.Continuation)

    /// Creates a new camera manager.
    public override init() {
        session = .init()
        ciContext = .init()
        (_cgImageUpdates, cgImageContinuation) = AsyncStream<CGImage>.makeStream()
        super.init()
    }

    /// Starts the camera capture session and returns an asynchronous stream of captured frames.
    ///
    /// The capture session automatically stops when the returned stream is terminated.
    ///
    /// - Parameter queue: The dispatch queue on which sample buffer delegates are called. Defaults to the main queue.
    /// - Returns: An `AsyncStream` that yields a `CGImage` for each captured video frame.
    /// - Throws: ``CameraError`` if the capture session cannot be configured.
    public func cgImageUpdates(queue: dispatch_queue_t? = .main) async throws -> AsyncStream<CGImage> {
        try configureCaptureSession(queue: queue)
        session.startRunning()
        cgImageContinuation.onTermination = { _ in
            self.session.stopRunning()
        }
        return _cgImageUpdates
    }

    /// Called when a new video frame is captured.
    ///
    /// This delegate method converts the sample buffer to a `CGImage` and yields it to the async stream.
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        cgImageContinuation.yield(cgImage)
    }

    private func configureCaptureSession(queue: dispatch_queue_t?) throws {
        session.beginConfiguration()
        session.sessionPreset = .high
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
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.setSampleBufferDelegate(self, queue: queue)
        output.connection(with: .video)?.isEnabled = true
        output.connection(with: .video)?.videoRotationAngle = 90
    }
}
