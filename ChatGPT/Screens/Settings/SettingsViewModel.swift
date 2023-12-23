//
//  SettingsViewModel.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-08-23.
//

import Factory
import Foundation

final class SettingsViewModel: ObservableObject {
    @Injected(\.storageChat) private var chatStorage
    @Injected(\.keychainManager) private var keychainManager
    private let gptTokenKey: String = "gptTokenKey"

    func deleteAllChats() {
        chatStorage.deleteAll()
    }

    func saveToken(_ token: String) {
        do {
            try keychainManager.saveStringItem(token, key: gptTokenKey)
            Container.shared.chatGPTAPI.reset()
        } catch {
            print("--- error saving token: \(error)")
        }
    }

    func getToken() -> String {
        do {
            return try keychainManager.getStringItem(key: gptTokenKey)
        } catch {
            print("--- error getting token: \(error)")
        }
        return ""
    }

    func removeToken() {
        do {
            try keychainManager.remove(key: gptTokenKey)
            Container.shared.chatGPTAPI.reset()
        } catch {
            print("--- error deleting token: \(error)")
        }
    }

    func checkForTokenSaved() -> Bool {
        return keychainManager.checkForExistingItem(key: gptTokenKey)
    }
}
