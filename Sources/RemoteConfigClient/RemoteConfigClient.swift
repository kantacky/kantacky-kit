//
//  RemoteConfigClient.swift
//
//
//  Created by Kanta Oikawa on 2024/09/04.
//

import Dependencies
import DependenciesMacros
import FirebaseRemoteConfig

@DependencyClient
public struct RemoteConfigClient: Sendable {
    public var fetchBool: @Sendable (_ key: RemoteConfigKey) async throws -> Bool
    public var fetchData: @Sendable (_ key: RemoteConfigKey) async throws -> Data
    public var fetchDouble: @Sendable (_ key: RemoteConfigKey) async throws -> Double
    public var fetchInt: @Sendable (_ key: RemoteConfigKey) async throws -> Int
    public var fetchString: @Sendable (_ key: RemoteConfigKey) async throws -> String
}

extension RemoteConfigClient: DependencyKey {
    public static let liveValue: RemoteConfigClient = {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        return RemoteConfigClient(
            fetchBool: { key in
                try await remoteConfig.fetchAndActivate()
                return remoteConfig.configValue(forKey: key.name).boolValue
            },
            fetchData: { key in
                try await remoteConfig.fetchAndActivate()
                return remoteConfig.configValue(forKey: key.name).dataValue
            },
            fetchDouble: { key in
                try await remoteConfig.fetchAndActivate()
                return remoteConfig.configValue(forKey: key.name).numberValue.doubleValue
            },
            fetchInt: { key in
                try await remoteConfig.fetchAndActivate()
                return remoteConfig.configValue(forKey: key.name).numberValue.intValue
            },
            fetchString: { key in
                try await remoteConfig.fetchAndActivate()
                return remoteConfig.configValue(forKey: key.name).stringValue
            }
        )
    }()
}

extension RemoteConfigClient: TestDependencyKey {
    public static let testValue = RemoteConfigClient()
    public static let previewValue = RemoteConfigClient(
        fetchBool: { _ in false },
        fetchData: { _ in Data() },
        fetchDouble: { _ in 0 },
        fetchInt: { _ in 0 },
        fetchString: { _ in "" }
    )
}
