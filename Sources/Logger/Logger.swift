//
//  Logger.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/08/29.
//

import Foundation
import os

public enum Logger {
    public static let standard = os.Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: Category.standard.rawValue.capitalized
    )

    public enum Category: String {
        case standard
    }
}
