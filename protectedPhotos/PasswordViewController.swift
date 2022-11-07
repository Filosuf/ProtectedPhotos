//
//  PasswordViewController.swift
//  protectedPhotos
//
//  Created by 1234 on 29.09.2022.
//

import UIKit
enum PasswordState: String {
    /// Создание пароля
    case createPassword = "Создать пароль"
    /// Создание пароля, повторный ввод
    case repeatPassword = "Повторите пароль"
    /// Пароль установлен, проверка введёного пароля
    case enterPassword = "Введите пароль"
}

class PasswordViewController: UIViewController {

    private lazy var passwordView = PasswordView(delegate: self)
    private let coordinator = MainCoordinatorImp(fileManagerService: FileManagerService(), passwordService: PasswordService())
    private let factory = FactoryVC(fileManagerService: FileManagerService())
    private let passwordService: PasswordServiceProtocol
    private var state: PasswordState {
        didSet {
            passwordView.setButtonTitle(state.rawValue)
        }
    }
    private var newPassword = ""

    // MARK: - Initialiser
    init(state: PasswordState, passwordService: PasswordServiceProtocol) {
        self.state = state
        self.passwordService = passwordService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.setButtonTitle(state.rawValue)
        view = passwordView
    }

//    private func showAlert(action: @escaping () -> Void) {
    private func showAlert(message: String) {
            // создаём объекты всплывающего окна
            let alert = UIAlertController(
                title: "Error", // заголовок всплывающего окна
                message: message, // текст во всплывающем окне
                preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

            // создаём для него кнопки с действиями
            let action = UIAlertAction(title: "Ok", style: .default) { _ in
                self.passwordView.clearTextField()
            }

            // добавляем в алерт кнопки
            alert.addAction(action)

            // показываем всплывающее окно
            present(alert, animated: true, completion: nil)
    }
}

extension PasswordViewController: PasswordViewDelegate {
    func didTapLogInButton(password: String) {
        switch state {
        case .createPassword:
            newPassword = passwordView.getPassword()
            passwordView.clearTextField()
            state = .repeatPassword
        case .repeatPassword:
            if newPassword == passwordView.getPassword() {
                passwordService.setPassword(newPassword)
                dismiss(animated: true, completion: nil)
            } else {
                state = .createPassword
                showAlert(message: "Пароли не совпадают. Попробуйте еще раз")
            }
        case .enterPassword:
            if passwordService.isValid(password: passwordView.getPassword()) {
                dismiss(animated: true, completion: nil)
            } else {
                showAlert(message: "Password is invalid")
            }
        }
    }

    private func setView(state: PasswordState) {
        switch state {
        case .createPassword:
            print(state)
        case .repeatPassword:
            print(state)
        case .enterPassword:
            print(state)
        }
        passwordView.setButtonTitle(state.rawValue)
    }

}
