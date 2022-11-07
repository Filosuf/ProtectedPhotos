//
//  SettingsStore.swift
//  protectedPhotos
//
//  Created by 1234 on 30.09.2022.
//

import Foundation

//Структура для хранения настроек
public struct Settings: Codable {
    var sort = true
    var sizeOnView = true

    enum Name: String {
        case sort = "Сортировка по имени"
        case sizeOnView = "Показывать размер фотографии"
        case newPassword = "Изменить пароль"
    }
}

/// Класс для сохранения и изменения настроек приложения.
public final class SettingsStore {

    /// Синглтон для изменения состояния настроек из разных модулей.
    public static let shared: SettingsStore = .init()

    /// Настройки сохраняются в UserDefaults и доступны после перезагрузки приложения.
    public var settings: Settings = Settings(sort: true, sizeOnView: true) {
        didSet {
            save()
        }
    }

    private lazy var userDefaults: UserDefaults = .standard

    private lazy var decoder: JSONDecoder = .init()

    private lazy var encoder: JSONEncoder = .init()

    // MARK: - Lifecycle
    private init() {
        guard let data = userDefaults.data(forKey: "settings") else {
            return
        }
        do {
            settings = try decoder.decode(Settings.self, from: data)
        }
        catch {
            print("Ошибка декодирования сохранённых настроек", error)
        }
    }

    // MARK: - Private
    /// Сохраняет все изменения в настройках в UserDefaults.
    public func save() {
        do {
            let data = try encoder.encode(settings)
            userDefaults.setValue(data, forKey: "settings")
        }
        catch {
            print("Ошибка кодирования настроек для сохранения", error)
        }
    }

}

