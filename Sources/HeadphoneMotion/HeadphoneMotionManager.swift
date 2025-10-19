//
//  HeadphoneMotionManager.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/19.
//

@preconcurrency import CoreMotion

public final class HeadphoneMotionManager: NSObject, CMHeadphoneMotionManagerDelegate, Sendable {
    private let manager: CMHeadphoneMotionManager

    nonisolated(unsafe) public private(set) var isConnectedStream: AsyncStream<Bool>
    nonisolated(unsafe) private var isConnectedContinuation: AsyncStream<Bool>.Continuation?

    public override init() {
        self.manager = .init()
        self.isConnectedStream = AsyncStream { _ in }
        super.init()
        manager.delegate = self
        self.isConnectedStream = AsyncStream { continuation in
            self.isConnectedContinuation = continuation
            continuation.onTermination = { _ in
                self.manager.stopConnectionStatusUpdates()
            }
        }
        manager.startConnectionStatusUpdates()
    }

    public func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        isConnectedContinuation?.yield(true)
    }

    public func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        isConnectedContinuation?.yield(false)
    }
}
