//
//  LocalSearchClient.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/09/04.
//

import Dependencies
import DependenciesMacros
import MapKit

@DependencyClient
public struct LocalSearchClient: Sendable {
    public var searchMapItem:
        @Sendable (_ searchQuery: String, _ region: MKCoordinateRegion?) async throws -> [MKMapItem]
    public var searchNearby:
        @Sendable (_ center: CLLocationCoordinate2D, _ radiusMeters: Double) async throws ->
            [MKMapItem]
}

extension LocalSearchClient: DependencyKey {
    public static let liveValue = LocalSearchClient(
        searchMapItem: { searchQuery, region in
            if searchQuery.isEmpty {
                return []
            }
            let request = MKLocalSearch.Request()
            if let region {
                request.region = region
            }
            request.resultTypes = [.address, .pointOfInterest]
            request.naturalLanguageQuery = searchQuery
            let search = MKLocalSearch(request: request)
            do {
                let response = try await search.start()
                return response.mapItems
            } catch {
                switch error {
                case MKError.placemarkNotFound:
                    return []

                default:
                    throw error
                }
            }
        },
        searchNearby: { center, radiusMeters in
            let request = MKLocalPointsOfInterestRequest(center: center, radius: radiusMeters)
            let search = MKLocalSearch(request: request)
            do {
                let response = try await search.start()
                return response.mapItems
            } catch {
                switch error {
                case MKError.placemarkNotFound:
                    return []

                default:
                    throw error
                }
            }
        }
    )
}

extension LocalSearchClient: TestDependencyKey {
    public static let testValue = LocalSearchClient()

    public static let previewValue = LocalSearchClient(
        searchMapItem: { _, _ in [] },
        searchNearby: { _, _ in [] }
    )
}
