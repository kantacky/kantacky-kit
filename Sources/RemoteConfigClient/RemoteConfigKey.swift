//
//  RemoteConfigKey.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/09/04.
//

import Foundation

/// Key struct for RemoteConfig values
///
/// Add `RemoteConfigKey` static values by extending this struct
///
/// ```
/// extension RemoteConfigKey {
///     static let testKey1 = RemoteConfigKey(name: "test_key1")
/// }
/// ```
public struct RemoteConfigKey: Sendable {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}
