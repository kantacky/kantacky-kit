//
//  Router.swift
//  Playground
//

import SwiftUI
import UIKit

final class Router {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func push(tab: AppTab, depth: Int) {
        let rootView = ScreenView(tab: tab, depth: depth)
            .environment(\.router, self)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.title = "\(tab.title) \(depth)"
        navigationController?.pushViewController(hostingController, animated: true)
    }

    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private struct RouterKey: EnvironmentKey {
    static let defaultValue: Router? = nil
}

extension EnvironmentValues {
    var router: Router? {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
