//
//  ListFlowCoordinator.swift
//  protectedPhotos
//
//  Created by 1234 on 17.09.2022.
//

import Foundation
import UIKit

final class ListFlowCoordinator {

    private let fileManagerService: FileManagerServiceProtocol
    private let navCon: UINavigationController
    private let passwordService: PasswordServiceProtocol = PasswordService()

    //MARK: - Initialiser
    init(navCon: UINavigationController, fileManagerService: FileManagerServiceProtocol) {
        self.navCon = navCon
        self.fileManagerService = fileManagerService
    }

    func push(startUrl: URL) {
        let vc = ListViewController(coordinator: self, fileManagerService: fileManagerService, startUrl: startUrl)
        navCon.pushViewController(vc, animated: true)
    }

    func showImage(with image: UIImage) {
        let vc = ImageViewController(image: image)
        navCon.pushViewController(vc, animated: true)
    }

    func pop() {
        navCon.popViewController(animated: true)
    }

    // проверка авторизован ли юзер
    // показать либо экран авторизации, либо новостную ленту
    func passwordVCPresent() {
        if passwordService.isSet() {
            let passwordVC = PasswordViewController(state: .enterPassword, passwordService: PasswordService())
            passwordVC.modalPresentationStyle = .fullScreen
            navCon.present(passwordVC, animated: true)
        } else {
            let passwordVC = PasswordViewController(state: .createPassword, passwordService: PasswordService())
            passwordVC.modalPresentationStyle = .fullScreen
            navCon.present(passwordVC, animated: true)
        }
    }
}
