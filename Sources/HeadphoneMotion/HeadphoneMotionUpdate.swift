//
//  HeadphoneMotionUpdate.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/16.
//

@preconcurrency import CoreMotion

/// Provides an asynchronous stream of headphone device motion data.
///
/// Use ``updates(queue:)`` to receive continuous `CMDeviceMotion` values from motion-capable headphones.
///
/// ```swift
/// for try await motion in try HeadphoneMotionUpdate.updates() {
///     print("Attitude: \(motion.attitude)")
/// }
/// ```
public enum HeadphoneMotionUpdate: Sendable {
    /// Starts headphone device motion updates and returns them as an asynchronous throwing stream.
    ///
    /// Motion updates stop automatically when the returned stream is terminated.
    ///
    /// - Parameter queue: The operation queue on which motion updates are delivered. Defaults to the current queue.
    /// - Returns: An `AsyncThrowingStream` that yields `CMDeviceMotion` values.
    /// - Throws: ``HeadphoneMotionError/notAvailable`` if the device does not support headphone motion,
    ///   or ``HeadphoneMotionError/notAuthorized(_:)`` if the app lacks authorization.
    public static func updates(queue: OperationQueue? = .current) throws -> AsyncThrowingStream<CMDeviceMotion, Error> {
        let manager = CMHeadphoneMotionManager()

        guard manager.isDeviceMotionAvailable else {
            throw HeadphoneMotionError.notAvailable
        }

        let authorizationStatus = CMHeadphoneMotionManager.authorizationStatus()

        switch authorizationStatus {
        case .denied, .restricted:
            throw HeadphoneMotionError.notAuthorized(authorizationStatus)

        default:
            break
        }

        return AsyncThrowingStream { continuation in
            manager.startDeviceMotionUpdates(to: queue ?? .main) { motion, error in
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                if let motion {
                    continuation.yield(motion)
                }
            }

            continuation.onTermination = { _ in
                manager.stopDeviceMotionUpdates()
            }
        }
    }
}
