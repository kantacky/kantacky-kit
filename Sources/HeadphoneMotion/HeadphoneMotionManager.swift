//
//  HeadphoneMotionManager.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/19.
//

@preconcurrency import CoreMotion

public final class HeadphoneMotionManager: NSObject, CMHeadphoneMotionManagerDelegate, Sendable {
    private let manager: CMHeadphoneMotionManager

    nonisolated(unsafe) private var isConnectedContinuation: AsyncStream<Bool>.Continuation?

    public override init() {
        self.manager = .init()
        super.init()
        manager.delegate = self
    }

    public func connectionUpdates() -> AsyncStream<Bool> {
        return AsyncStream { continuation in
            isConnectedContinuation = continuation
            continuation.yield(manager.isDeviceMotionActive)
        }
    }

    public func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        isConnectedContinuation?.yield(true)
    }

    public func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        isConnectedContinuation?.yield(false)
    }
}
