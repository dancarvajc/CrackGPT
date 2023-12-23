//
//  KeychainManager.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 03-09-23.
//

import Foundation
import KeychainAccess

protocol KeychainManagerProtocol {
    func saveStringItem(_ item: String, key: String) throws
    func saveDataItem(_ item: Data, key: String) throws
    func getStringItem(key: String) throws -> String
    func getDataItem(key: String) throws -> Data
    func checkForExistingItem(key: String) -> Bool
    func remove(key: String) throws
    func removeAll() throws
}

final class KeychainManager: KeychainManagerProtocol {
    private let keychain = Keychain()

    func saveStringItem(_ item: String, key: String) throws {
        try keychain.set(item, key: key)
    }

    func saveDataItem(_ item: Data, key: String) throws {
        try keychain.set(item, key: key)
    }

    func getStringItem(key: String) throws -> String {
        do {
            guard let stringItem = try keychain.getString(key) else {
                throw NSError(domain: NSCocoaErrorDomain,
                              code: NSKeyValueValidationError,
                              userInfo: [NSLocalizedDescriptionKey: "Can't get the item with key \(key)"])
            }
            return stringItem
        } catch {
            throw error
        }
    }

    func checkForExistingItem(key: String) -> Bool {
        let result = try? keychain.contains(key)
        return result ?? false
    }

    func getDataItem(key: String) throws -> Data {
        do {
            guard let dataItem = try keychain.getData(key) else {
                throw NSError(domain: NSCocoaErrorDomain,
                              code: NSKeyValueValidationError,
                              userInfo: [NSLocalizedDescriptionKey: "Can't get the item with key \(key)"])
            }
            return dataItem
        } catch {
            throw error
        }
    }

    func remove(key: String) throws {
        try keychain.remove(key)
    }

    func removeAll() throws {
        try keychain.removeAll()
    }
}
