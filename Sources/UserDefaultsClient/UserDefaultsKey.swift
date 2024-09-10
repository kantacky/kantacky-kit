//
//  UserDefaultsKey.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/09/04.
//

import Foundation

/// Key struct for UserDefaults values
///
/// Add `UserDefaultsKey` static values by extending this struct
///
/// ```
/// extension UserDefaultsKey {
///     static let testKey1 = UserDefaultsKey(name: "test_key1")
/// }
/// ```
public struct UserDefaultsKey: Sendable {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}
