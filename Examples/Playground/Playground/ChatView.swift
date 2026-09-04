//
//  ChatView.swift
//  kantacky-kit
//
//  Created by 及川 寛太 on 2026/08/24.
//

import SwiftUI

struct ChatView: View {
    @State private var items: [Int] = (0..<100).map { $0 }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ProgressView()
                            .onAppear {
                                Task {
                                    try? await Task.sleep(for: .seconds(1))
                                    items.insert(
                                        contentsOf: items[0]-20..<items[0],
                                        at: 0
                                    )
                                }
                            }
                        ForEach(items, id: \.self) { item in
                            Text(item.description)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                }
                .defaultScrollAnchor(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        items = (0..<100).map { $0 }
                    }
                }
                ToolbarItem {
                    Button("Add") {
                        items.append(items.count)
                    }
                }
            }
        }
    }
}

#Preview {
    ChatView()
}
