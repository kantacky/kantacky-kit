//
//  HeadphoneMotionManager.swift
//  kantacky-kit
//
//  Created by Kanta Oikawa on 2025/10/19.
//

@preconcurrency import CoreMotion

/// A manager that tracks headphone connection status and delivers updates via an `AsyncStream`.
///
/// `HeadphoneMotionManager` wraps `CMHeadphoneMotionManager` to provide an async-friendly interface
/// for monitoring whether motion-capable headphones are connected.
///
/// ```swift
/// let manager = HeadphoneMotionManager()
/// for await isConnected in manager.connectionUpdates() {
///     print("Headphones connected: \(isConnected)")
/// }
/// ```
public final class HeadphoneMotionManager: NSObject, CMHeadphoneMotionManagerDelegate, Sendable {
    private let manager: CMHeadphoneMotionManager
    private let (_connectionUpdates, connectionContinuation): (AsyncStream<Bool>, AsyncStream<Bool>.Continuation)

    /// Creates a new headphone motion manager and begins monitoring connection status.
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

    /// Returns an asynchronous stream of headphone connection status updates.
    ///
    /// The stream yields `true` when headphones connect and `false` when they disconnect.
    /// Connection status monitoring stops when the stream is terminated.
    ///
    /// - Returns: An `AsyncStream` of `Bool` values representing the connection state.
    public func connectionUpdates() -> AsyncStream<Bool> {
        _connectionUpdates
    }

    /// Called when motion-capable headphones connect.
    public func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        connectionContinuation.yield(true)
    }

    /// Called when motion-capable headphones disconnect.
    public func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        connectionContinuation.yield(false)
    }
}
