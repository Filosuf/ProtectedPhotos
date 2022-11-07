//
//  FactoryVC.swift
//  protectedPhotos
//
//  Created by 1234 on 03.10.2022.
//

import Foundation
import UIKit

enum TabBarPage {
    case list
    case settings

    var pageTitle: String {
        switch self {
        case .list:
            return "Проводник"
        case .settings:
            return "Настройки"
        }
    }

    var image: UIImage? {
        switch self {
        case .list:
            return UIImage(systemName: "folder.fill")
        case .settings:
            return UIImage(systemName: "gearshape.fill")
        }
    }
}

final class FactoryVC {
    private let fileManagerService: FileManagerServiceProtocol

    init(fileManagerService: FileManagerServiceProtocol) {
        self.fileManagerService = fileManagerService
    }

    // MARK: - Metods
    func getTabBarController() -> UIViewController {
        let tabBarVC = UITabBarController()
        let pages: [TabBarPage] = [.list, .settings]

        tabBarVC.setViewControllers(pages.map { getNavController(page: $0) }, animated: true)
        return tabBarVC
    }

    private func getNavController(page: TabBarPage) -> UINavigationController {
        let navigationVC = UINavigationController()
        navigationVC.tabBarItem.image = page.image
        navigationVC.tabBarItem.title = page.pageTitle

        switch page {
        case .list:
            let listChildCoordinator = ListFlowCoordinator(navCon: navigationVC, fileManagerService: fileManagerService)
            let listVC = ListViewController(
                coordinator: listChildCoordinator,
                fileManagerService: fileManagerService,
                startUrl: fileManagerService.documentsUrl,
                checkPassword: true
            )
            navigationVC.pushViewController(listVC, animated: true)
        case .settings:
            let settingsVC = SettingsViewController()
            navigationVC.pushViewController(settingsVC, animated: true)
        }

        return navigationVC
    }
}
