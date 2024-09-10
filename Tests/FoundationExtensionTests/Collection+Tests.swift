//
//  Collection+Tests.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/08/28.
//

import FoundationExtension
import Testing

@Suite struct CollectionExtensionTests {
    @Test func subscriptSafely() async throws {
        let items = ["A", "B", "C"]
        #expect(items[safe: 0] == "A")
        #expect(items[safe: 1] == "B")
        #expect(items[safe: 2] == "C")
        #expect(items[safe: 3] == nil)
    }
}
