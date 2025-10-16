//
//  HeadphoneMotionUpdate.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/16.
//

@preconcurrency import CoreMotion

public enum HeadphoneMotionUpdate: Sendable {
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
