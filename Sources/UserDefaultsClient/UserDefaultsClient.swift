//
//  UserDefaultsClient.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/09/04.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct UserDefaultsClient: Sendable {
    public var getArray: @Sendable (_ forKey: UserDefaultsKey) async throws -> [Data]
    public var getBool: @Sendable (_ forKey: UserDefaultsKey) async throws -> Bool
    public var getData: @Sendable (_ forKey: UserDefaultsKey) async -> Data?
    public var getDouble: @Sendable (_ forKey: UserDefaultsKey) async throws -> Double
    public var getInt: @Sendable (_ forKey: UserDefaultsKey) async throws -> Int
    public var getString: @Sendable (_ forKey: UserDefaultsKey) async throws -> String
    public var remove: @Sendable (_ forKey: UserDefaultsKey) async -> Void
    public var setArray: @Sendable (_ value: [Data], _ forKey: UserDefaultsKey) async -> Void
    public var setBool: @Sendable (_ value: Bool, _ forKey: UserDefaultsKey) async -> Void
    public var setData: @Sendable (_ value: Data, _ forKey: UserDefaultsKey) async -> Void
    public var setDouble: @Sendable (_ value: Double, _ forKey: UserDefaultsKey) async -> Void
    public var setInt: @Sendable (_ value: Int, _ forKey: UserDefaultsKey) async -> Void
    public var setString: @Sendable (_ value: String, _ forKey: UserDefaultsKey) async -> Void
}

extension UserDefaultsClient: DependencyKey {
    public static let liveValue: Self = UserDefaultsClient(
        getArray: { UserDefaults.standard.array(forKey: $0.name) as? [Data] ?? [] },
        getBool: { UserDefaults.standard.bool(forKey: $0.name) },
        getData: { UserDefaults.standard.data(forKey: $0.name) },
        getDouble: { UserDefaults.standard.double(forKey: $0.name) },
        getInt: { UserDefaults.standard.integer(forKey: $0.name) },
        getString: { UserDefaults.standard.string(forKey: $0.name) ?? "" },
        remove: { UserDefaults.standard.removeObject(forKey: $0.name) },
        setArray: { UserDefaults.standard.set($0, forKey: $1.name) },
        setBool: { UserDefaults.standard.set($0, forKey: $1.name) },
        setData: { UserDefaults.standard.set($0, forKey: $1.name) },
        setDouble: { UserDefaults.standard.set($0, forKey: $1.name) },
        setInt: { UserDefaults.standard.set($0, forKey: $1.name) },
        setString: { UserDefaults.standard.set($0, forKey: $1.name) }
    )
}

extension UserDefaultsClient: TestDependencyKey {
    public static let testValue = UserDefaultsClient()
    public static let previewValue = UserDefaultsClient(
        getArray: { _ in [] },
        getBool: { _ in false },
        getData: { _ in Data() },
        getDouble: { _ in 0 },
        getInt: { _ in 0 },
        getString: { _ in "" },
        remove: { _ in },
        setArray: { _, _ in },
        setBool: { _, _ in },
        setData: { _, _ in },
        setDouble: { _, _ in },
        setInt: { _, _ in },
        setString: { _, _ in }
    )
}
