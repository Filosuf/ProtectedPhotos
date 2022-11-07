//
//  SettingsViewController.swift
//  protectedPhotos
//
//  Created by 1234 on 27.09.2022.
//

import UIKit

struct SettingCell {
    let label: String
    let icon: UIImage
    let switchIsOn: Bool?
}


final class SettingsViewController: UIViewController {

    private var settingsViewModel = [SettingCell]()
    private var settingsValue: Settings {
        get { SettingsStore.shared.settings }
        set { SettingsStore.shared.settings = newValue }
    }

    private let settingsView = SettingsView()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        settingsView.setTable(delegate: self, dataSource: self)
        settingsViewModel = getSettings()
    }

    // MARK: - Methods
    private func getSettings() -> [SettingCell] {
        let settings = [
            getCell(for: .sort),
            getCell(for: .sizeOnView),
            getCell(for: .newPassword)
        ]
        return settings
    }

    private func getCell(for setting: Settings.Name) -> SettingCell {
        let label = setting.rawValue
        var icon: UIImage
        var isOn: Bool?

        switch setting {
        case .sort:
            icon = UIImage(systemName: "arrow.up.arrow.down")!
            isOn = settingsValue.sort
        case .sizeOnView:
            icon = UIImage(systemName: "info.circle")!
            isOn = settingsValue.sizeOnView
        case .newPassword:
            icon = UIImage(systemName: "key.fill")!
        }
        return SettingCell(label: label, icon: icon, switchIsOn: isOn)
    }

    private func updateSettings(for identifier: String, with value: Bool) {
        switch identifier {
        case Settings.Name.sort.rawValue:
            self.settingsValue.sort = value
        case Settings.Name.sizeOnView.rawValue:
            self.settingsValue.sizeOnView = value
        default:
            print("Настройка \(identifier) не найдена")
        }
    }

    private func layout() {
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        [settingsView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([

            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsViewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        cell.configure(with: settingsViewModel[indexPath.row])
        cell.buttonAction = { [weak self] isOn in
            guard let self = self else { return }

            let identifier = self.settingsViewModel[indexPath.row].label
            self.updateSettings(for: identifier, with: isOn)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let identifier = settingsViewModel[indexPath.row].label
        if identifier == Settings.Name.newPassword.rawValue {
            let passwordVC = PasswordViewController(state: .createPassword, passwordService: PasswordService())
            present(passwordVC, animated: true)
        }
    }

    // Create a standard header that includes the returned text.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Для того чтобы заглавной была только первая буква, имя задаётся в настройках (шрифт, цвет, фон) заголовка
        return "_"
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header = view as! UITableViewHeaderFooterView

        // Установить цвет текста в label
        header.textLabel?.textColor = .black

        // Установить цвет фона для секции
        header.tintColor = UIColor.white

        // Установить название для заголовка
        header.textLabel?.text = "Settings"

        // Установить шрифт и/или размер шрифта для label
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }
}
