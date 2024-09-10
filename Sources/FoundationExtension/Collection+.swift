//
//  Collection+.swift
//  KantackyKit
//
//  Created by Kanta Oikawa on 2024/08/28.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
