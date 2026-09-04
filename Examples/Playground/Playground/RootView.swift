//
//  RootView.swift
//  Playground
//

import SwiftUI
import UIKit

struct RootView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        TabBarController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    RootView()
        .ignoresSafeArea()
}
