//
//  MainCoordinator.swift
//  protectedPhotos
//
//  Created by 1234 on 27.09.2022.
//

import Foundation
import UIKit

protocol MainCoordinator {
    func startApplication() -> UIViewController
}

final class MainCoordinatorImp: MainCoordinator {

    private let factory = FactoryVC(fileManagerService: FileManagerService())
    private let passwordService: PasswordServiceProtocol

    // MARK: - Initialiser
    init(fileManagerService: FileManagerServiceProtocol, passwordService: PasswordServiceProtocol) {
//        self.fileManagerService = fileManagerService
        self.passwordService = passwordService
    }

    // MARK: - Metods
    // проверка авторизован ли юзер
    // показать либо экран авторизации, либо новостную ленту
    func startApplication() -> UIViewController {
        if passwordService.isSet() {
            return PasswordViewController(state: .enterPassword, passwordService: PasswordService())
        } else {
            return PasswordViewController(state: .createPassword, passwordService: PasswordService())
        }
    }

    func pushTabBar(navCon: UINavigationController) {
        let vc = factory.getTabBarController()
        navCon.pushViewController(vc, animated: true)
    }
}
