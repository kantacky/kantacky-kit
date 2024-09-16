//
//  LocationManager.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/08/24.
//

import CoreLocation
import Logger

final actor LocationManager: NSObject {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
    }

    private init(
        desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBestForNavigation,
        distanceFilter: CLLocationDistance = 1,
        activityType: CLActivityType = .fitness
    ) {
        self.init()
        Task {
            await setDesiredAccuracy(desiredAccuracy)
            await setDistanceFilter(distanceFilter)
            await setActivityType(activityType)
        }
    }

    var locationServiceEnabled: Bool { CLLocationManager.locationServicesEnabled() }

    var location: CLLocation? { locationManager.location }
    private var locationChangeHandler: @Sendable (CLLocation) -> Void = { _ in }
    var locationStream: AsyncStream<CLLocation> {
        AsyncStream { continuation in
            locationChangeHandler = { continuation.yield($0) }
        }
    }

    var heading: CLHeading? { locationManager.heading }
    private var headingChangeHandler: @Sendable (CLHeading) -> Void = { _ in }
    var headingStream: AsyncStream<CLHeading> {
        AsyncStream { continuation in
            headingChangeHandler = { continuation.yield($0) }
        }
    }

    var authorizationStatus: CLAuthorizationStatus { locationManager.authorizationStatus }
    private var authorizationStatusChangeHandler: @Sendable (CLAuthorizationStatus) -> Void = { _ in
    }
    var authorizationStatusStream: AsyncStream<CLAuthorizationStatus> {
        AsyncStream { continuation in
            authorizationStatusChangeHandler = { continuation.yield($0) }
        }
    }

    var accuracyAuthorization: CLAccuracyAuthorization { locationManager.accuracyAuthorization }
    private var accuracyAuthorizationChangeHandler: @Sendable (CLAccuracyAuthorization) -> Void = {
        _ in
    }
    var accuracyAuthorizationStream: AsyncStream<CLAccuracyAuthorization> {
        AsyncStream { continuation in
            accuracyAuthorizationChangeHandler = { continuation.yield($0) }
        }
    }
}

extension LocationManager {
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
        } else {
            Logger.standard.error("Heading is not available.")
        }
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }

    func enableBackgroundLocationUpdates() {
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func disableBackgroundLocationUpdates() {
        locationManager.allowsBackgroundLocationUpdates = false
    }

    func setDesiredAccuracy(_ accuracy: CLLocationAccuracy) {
        locationManager.desiredAccuracy = accuracy
    }

    func setDistanceFilter(_ distance: CLLocationDistance) {
        locationManager.distanceFilter = distance
    }

    func setActivityType(_ type: CLActivityType) {
        locationManager.activityType = type
    }
}

extension LocationManager: CLLocationManagerDelegate {
    nonisolated func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else {
            return
        }
        Task {
            await locationChangeHandler(location)
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager, didUpdateHeading heading: CLHeading
    ) {
        Task {
            await headingChangeHandler(heading)
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task {
            await authorizationStatusChangeHandler(manager.authorizationStatus)
            await accuracyAuthorizationChangeHandler(manager.accuracyAuthorization)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.standard.error("\(error.localizedDescription)")
    }
}

extension CLLocationManager: @retroactive @unchecked Sendable {}

extension CLHeading: @retroactive @unchecked Sendable {}
