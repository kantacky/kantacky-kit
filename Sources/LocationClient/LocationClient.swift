//
//  LocationClient.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/08/24.
//

import CoreLocation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct LocationClient: Sendable {
    public var requestWhenInUseAuthorization: @Sendable () async -> Void
    public var requestAlwaysUseAuthorization: @Sendable () async -> Void

    public var getAuthorizationStatus: @Sendable () async throws -> CLAuthorizationStatus
    public var getAuthorizationStatusStream: @Sendable () async throws -> AsyncStream<CLAuthorizationStatus>

    public var getAccuracyAuthorization: @Sendable () async throws -> CLAccuracyAuthorization
    public var getAccuracyAuthorizationStream: @Sendable () async throws -> AsyncStream<CLAccuracyAuthorization>

    public var startUpdatingLocation: @Sendable () async -> Void
    public var stopUpdatingLocation: @Sendable () async -> Void

    public var enableBackgroundLocationUpdates: @Sendable () async -> Void
    public var disableBackgroundLocationUpdates: @Sendable () async -> Void

    public var setDesiredAccuracy: @Sendable (CLLocationAccuracy) async -> Void
    public var setDistanceFilter: @Sendable (CLLocationDistance) async -> Void
    public var setActivityType: @Sendable (CLActivityType) async -> Void

    public var getLocation: @Sendable () async -> CLLocation?
    public var getLocationStream: @Sendable () async throws -> AsyncStream<CLLocation>

    public var getHeading: @Sendable () async -> CLHeading?
    public var getHeadingStream: @Sendable () async throws -> AsyncStream<CLHeading>
}

extension LocationClient: DependencyKey {
    public static let liveValue = { @Sendable in
        let locationManager = LocationManager()

        return LocationClient(
            requestWhenInUseAuthorization: {
                locationManager.requestWhenInUseAuthorization()
            },
            requestAlwaysUseAuthorization: {
                locationManager.requestAlwaysAuthorization()
            },
            getAuthorizationStatus: {
                locationManager.authorizationStatus
            },
            getAuthorizationStatusStream: {
                locationManager.authorizationStatusStream
            },
            getAccuracyAuthorization: {
                locationManager.accuracyAuthorization
            },
            getAccuracyAuthorizationStream: {
                locationManager.accuracyAuthorizationStream
            },
            startUpdatingLocation: {
                locationManager.startUpdatingLocation()
            },
            stopUpdatingLocation: {
                locationManager.stopUpdatingLocation()
            },
            enableBackgroundLocationUpdates: {
                locationManager.enableBackgroundLocationUpdates()
            },
            disableBackgroundLocationUpdates: {
                locationManager.disableBackgroundLocationUpdates()
            },
            setDesiredAccuracy: {
                locationManager.setDesiredAccuracy($0)
            },
            setDistanceFilter: {
                locationManager.setDistanceFilter($0)
            },
            setActivityType: {
                locationManager.setActivityType($0)
            },
            getLocation: {
                locationManager.location
            },
            getLocationStream: {
                locationManager.locationStream
            },
            getHeading: {
                locationManager.heading
            },
            getHeadingStream: {
                locationManager.headingStream
            }
        )
    }()
}

extension LocationClient: TestDependencyKey {
    public static let testValue = LocationClient()

    public static let previewValue = LocationClient(
        requestWhenInUseAuthorization: {},
        requestAlwaysUseAuthorization: {},
        getAuthorizationStatus: { .authorizedWhenInUse },
        getAuthorizationStatusStream: {
            AsyncStream { continuation in
                continuation.yield(.authorizedAlways)
            }
        },
        getAccuracyAuthorization: { .fullAccuracy },
        getAccuracyAuthorizationStream: {
            AsyncStream { continuation in
                continuation.yield(.reducedAccuracy)
            }
        },
        startUpdatingLocation: {},
        stopUpdatingLocation: {},
        enableBackgroundLocationUpdates: {},
        disableBackgroundLocationUpdates: {},
        setDesiredAccuracy: { _ in },
        setDistanceFilter: { _ in },
        setActivityType: { _ in },
        getLocation: { CLLocation(latitude: 37.334886, longitude: -122.008988) },
        getLocationStream: {
            AsyncStream { continuation in
                continuation.yield(CLLocation(latitude: 37.334886, longitude: -122.008988))
            }
        },
        getHeading: { CLHeading() },
        getHeadingStream: {
            AsyncStream { continuation in
                continuation.yield(CLHeading())
            }
        }
    )
}
