//
//  ChatGPTApp+Injection.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 14-11-23.
//
import Factory
import Foundation
import OpenAI

extension Container {
    var storageGPTPersonality: Factory<StorageGPTPersonalityProtocol> {
        self { CDStorageGPTPersonalityRepository(context: self.coreDataStack().mainContext) }
    }

    var storageChat: Factory<StorageChatRepositoryProtocol> {
        self { CDStorageChatRepository(context: self.coreDataStack().mainContext) }
    }

    var storageSidebar: Factory<StorageSidebarRepositoryProtocol> {
        self { CDStorageSidebarRepository(context: self.coreDataStack().mainContext) }
    }

    var chatGPTRepository: Factory<ChatGPTRepositoryProtocol> {
        self { OpenAIRepository() }
    }

    var coreDataStack: Factory<CoreDataStack> {
        #if DEBUG
        self { CoreDataStack(forPreview: true) }
            .scope(.singleton)
        #else
        self { CoreDataStack(forPreview: false) }
            .scope(.singleton)
        #endif
    }

    var keychainManager: Factory<KeychainManagerProtocol> {
        self { KeychainManager() }
    }

    var speakService: Factory<SpeakServiceProtocol> {
        self { SpeakService() }
    }

    var chatGPTAPI: Factory<OpenAI> {
        let token = try? keychainManager().getStringItem(key: "gptTokenKey")
        return self { OpenAI(apiToken: token ?? "") }.scope(.singleton)
    }
}
