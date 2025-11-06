//
//  HeadphoneMotionManager.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/19.
//

@preconcurrency import CoreMotion

public final class HeadphoneMotionManager: NSObject, CMHeadphoneMotionManagerDelegate, Sendable {
    private let manager: CMHeadphoneMotionManager
    private let (_connectionUpdates, connectionContinuation): (AsyncStream<Bool>, AsyncStream<Bool>.Continuation)

    public override init() {
        self.manager = .init()
        (_connectionUpdates, connectionContinuation) = AsyncStream<Bool>.makeStream()
        super.init()
        manager.delegate = self
        manager.startConnectionStatusUpdates()
        connectionContinuation.onTermination = { _ in
            self.manager.stopConnectionStatusUpdates()
        }
    }

    public func connectionUpdates() -> AsyncStream<Bool> {
        _connectionUpdates
    }

    public func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        connectionContinuation.yield(true)
    }

    public func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        connectionContinuation.yield(false)
    }
}
