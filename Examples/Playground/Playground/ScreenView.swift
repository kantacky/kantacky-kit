//
//  ScreenView.swift
//  Playground
//

import SwiftUI

struct ScreenView: View {
    let tab: AppTab
    let depth: Int

    @Environment(\.router) private var router

    private static let maxDepth = 3

    var body: some View {
        List {
            Section {
                Label("\(tab.title) タブ / 画面\(depth)", systemImage: tab.systemImage)
            }

            if depth < Self.maxDepth {
                Button("画面\(depth + 1)へPush") {
                    router?.push(tab: tab, depth: depth + 1)
                }
            }

            if depth > 1 {
                Button("ルートまで戻る") {
                    router?.popToRoot()
                }
            }
        }
        .navigationTitle("\(tab.title) \(depth)")
    }
}

#Preview {
    NavigationStack {
        ScreenView(tab: .first, depth: 1)
    }
}
