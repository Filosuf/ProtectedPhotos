//
//  PasswordView.swift
//  protectedPhotos
//
//  Created by 1234 on 30.09.2022.
//

import UIKit
protocol PasswordViewDelegate: AnyObject {
    func didTapLogInButton(password: String)
}

class PasswordView: UIView {

    // MARK: - Properties
    private var delegate: PasswordViewDelegate?
    private let nc = NotificationCenter.default

    private let scrollView: UIScrollView = {

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private let contentView: UIView = {

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        return contentView
    }()

    private lazy var passwordTextField: UITextField = {

        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.tintColor = UIColor(named: "#4885CC")
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = UITextField.ViewMode.always
        textField.delegate = self
        textField.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:textField.frame.height))
        textField.rightView = UIView(frame:CGRect(x:0, y:0, width:10, height:textField.frame.height))
        textField.rightViewMode = .always
        textField.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)

        return textField
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль должен быть не менее 4 символов"
        label.textColor = .systemGray4
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let logInButton: UIButton = {

        let button = UIButton()
        button.setTitle("Check password", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true

        return button
    }()

    //MARK: - LifeCicle
    init(delegate: PasswordViewDelegate) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
        backgroundColor = .white
        addObserver()
        layout()
//        taps()
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObserver()
    }

    //MARK: - Metods
    ///Проверка длины введенного пароля
    @objc private func textFieldEditing() {
        guard let symbolsOfNumber = passwordTextField.text?.count else { return }
        if symbolsOfNumber < 4 {
            logInButton.isEnabled = false
            infoLabel.isHidden = false
        } else {
            logInButton.isEnabled = true
            infoLabel.isHidden = true
        }
    }

    private func addObserver() {
        nc.addObserver(self, selector: #selector(kdbShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kdbHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    private func removeObserver() {
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func kdbShow(notification: NSNotification) {
        if let kdbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = kdbSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kdbSize.height, right: 0)
        }
    }

    @objc private func kdbHide() {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    @objc private func buttonTapped() {
        delegate?.didTapLogInButton(password: passwordTextField.text!)
        print("button tapped")
    }

    func setButtonTitle(_ title: String) {
        logInButton.setTitle(title, for: .normal)
    }

    func clearTextField() {
        passwordTextField.text = ""
        logInButton.isEnabled = false
        infoLabel.isHidden = false
    }

    func getPassword() -> String{
        passwordTextField.text!
    }

    private func layout() {
        [
         passwordTextField,
         infoLabel,
         logInButton
        ].forEach { contentView.addSubview($0)}

        scrollView.addSubview(contentView)
        addSubview(scrollView)

        NSLayoutConstraint.activate([

                    passwordTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
                    passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    passwordTextField.heightAnchor.constraint(equalToConstant: 50),

                    infoLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 3),
                    infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                    logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 35),
                    logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    logInButton.heightAnchor.constraint(equalToConstant: 50),
                    logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

                    scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
    }
}

//MARK: - UITextFieldDelegate

extension PasswordView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
