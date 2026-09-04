//
//  AppTab.swift
//  Playground
//

import Foundation

enum AppTab: Int, CaseIterable {
    case first
    case second
    case third

    var title: String {
        switch self {
        case .first:
            return "First"
        case .second:
            return "Second"
        case .third:
            return "Third"
        }
    }

    var systemImage: String {
        switch self {
        case .first:
            return "1.circle"
        case .second:
            return "2.circle"
        case .third:
            return "3.circle"
        }
    }
}
