//
//  PasswordService.swift
//  protectedPhotos
//
//  Created by 1234 on 30.09.2022.
//

import Foundation

protocol PasswordServiceProtocol {
    ///Установка нового пароля
    func setPassword(_ password: String)

    ///Проверка валидности пароля
    func isValid(password: String) -> Bool

    ///Проверка установлен ли пароль
    func isSet() -> Bool
}


final class PasswordService: PasswordServiceProtocol {
    
    private let accountName = "accountName"
    private let serviceName = "serviceName"

    func isSet() -> Bool {
        getPassword() != nil
    }

    func setPassword(_ password: String) {
        if getPassword() == nil {
            setPassword(password: password)
        } else {
            updatePassword(password: password)
        }
    }

    func isValid(password: String) -> Bool {
        if let keyChainPass = getPassword() {
            return keyChainPass == password
        }
        return false
    }


//==============================================
private func setPassword(password: String) {
    // Переводим пароль в объект типа Data.
    guard let passData = password.data(using: .utf8) else {
        print("Невозможно получить данные типа Data из пароля.")
        return
    }

    // Создаем атрибуты для хранения файла.
    let attributes = [
        kSecClass: kSecClassGenericPassword,
        kSecValueData: passData,
        kSecAttrAccount: accountName,
        kSecAttrService: serviceName,
    ] as CFDictionary

    // Добавляем новую запись в Keychain. nil - указатель на объекты, которые были добавлены в базу данных Keychain.
    let status = SecItemAdd(attributes, nil)

    guard status == errSecSuccess else {
        print("Невозможно добавить пароль, ошибка номер: \(status).")
        return
    }

    print("Новый пароль добавлен успешно.")
}

private func getPassword() -> String? {
    // Создаем поисковые атрибуты.
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: serviceName,
        kSecAttrAccount: accountName,
        kSecReturnData: true
    ] as CFDictionary

    // Объявляем ссылку на объект, которая в будущем будет указывать на полученную запись Keychain.
    var extractedData: AnyObject?
    // Запрашиваем запись в Keychain.
    let status = SecItemCopyMatching(query, &extractedData)

    guard status != errSecItemNotFound else {
        print("Пароль не найден в Keychain.")
        return nil
    }

    guard status == errSecSuccess else {
        print("Невозможно получить пароль, ошибка номер: \(status).")
        return nil
    }

    guard let passData = extractedData as? Data,
          let password = String(data: passData, encoding: .utf8) else {
        print("Невозможно преобразовать Data в пароль.")
        return nil
    }

    return password
}

private func updatePassword(password: String) {
    // Переводим пароль в объект типа Data.
    guard let passData = password.data(using: .utf8) else {
        print("Невозможно получить Data из пароля.")
        return
    }

    // Создаем поисковые атрибуты.
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: serviceName,
        kSecAttrAccount: accountName,
        kSecReturnData: false // Не обязательно, false по-умолчанию.
    ] as CFDictionary

    let attributesToUpdate = [
        kSecValueData: passData,
    ] as CFDictionary

    let status = SecItemUpdate(query, attributesToUpdate)

    guard status == errSecSuccess else {
        print("Невозможно обновить пароль, ошибка номер: \(status).")
        return
    }

    print("Пароль обновлен успешно.")
}

private func deletePassword() {
    // Создаем поисковые атрибуты
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: serviceName,
        kSecAttrAccount: accountName,
        kSecReturnData: false  // Не обязательно, false по-умолчанию.
    ] as CFDictionary

    let status = SecItemDelete(query)

    guard status == errSecSuccess else {
        print("Невозможно удалить пароль, ошибка номер: \(status).")
        return
    }

    print("Пароль удален успешно.")
}


private func decodeStatus(_ status: OSStatus) {
    switch status {
    case errSecSuccess:
        print("Keychain Status: No error.")
    case errSecUnimplemented:
        print("Keychain Status: Function or operation not implemented.")
    case errSecIO:
        print("Keychain Status: I/O error (bummers)")
    case errSecOpWr:
        print("Keychain Status: File already open with with write permission")
    case errSecParam:
        print("Keychain Status: One or more parameters passed to a function where not valid.")
    case errSecAllocate:
        print("Keychain Status: Failed to allocate memory.")
    case errSecUserCanceled:
        print("Keychain Status: User canceled the operation.")
    case errSecBadReq:
        print("Keychain Status: Bad parameter or invalid state for operation.")
    case errSecInternalComponent:
        print("Keychain Status: Internal Component")
    case errSecNotAvailable:
        print("Keychain Status: No keychain is available. You may need to restart your computer.")
    case errSecDuplicateItem:
        print("Keychain Status: The specified item already exists in the keychain.")
    case errSecItemNotFound:
        print("Keychain Status: The specified item could not be found in the keychain.")
    case errSecInteractionNotAllowed:
        print("Keychain Status: User interaction is not allowed.")
    case errSecDecode:
        print("Keychain Status: Unable to decode the provided data.")
    case errSecAuthFailed:
        print("Keychain Status: The user name or passphrase you entered is not correct.")
    default:
        print("Keychain Status: Unknown. (\(status))")
    }
}

}
