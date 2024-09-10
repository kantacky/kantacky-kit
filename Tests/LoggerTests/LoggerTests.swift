//
//  LoggerTests.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/09/04.
//

import Logger
import Testing

@Suite struct LoggerTests {
    @Test func log() {
        Logger.standard.info("Test")
    }
}
