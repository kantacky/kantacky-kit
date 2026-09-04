//
//  TabBarController.swift
//  Playground
//

import SwiftUI
import UIKit

final class TabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)

        setViewControllers(
            AppTab.allCases.map(Self.makeNavigationController(tab:)),
            animated: false
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func makeNavigationController(tab: AppTab) -> UINavigationController {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)

        let rootView = ScreenView(tab: tab, depth: 1)
            .environment(\.router, router)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.title = "\(tab.title) 1"

        navigationController.setViewControllers([hostingController], animated: false)
        navigationController.tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.systemImage),
            tag: tab.rawValue
        )

        return navigationController
    }
}
