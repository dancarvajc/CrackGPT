//
//  MainViewModel.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 16-04-23.
//

#if canImport(AppKit)
import AppKit
#endif
import Factory
import Foundation
import OpenAI

final class MainViewModel: ObservableObject {
    @Published var sidebarList: [ChatSidebar] = []
    @Published private(set) var chatGPTMessage: String = "..."
    @Injected(\.storageSidebar) private var sidebarStorage
    @Injected(\.coreDataStack) private var coreDataStack
    @Injected(\.chatGPTAPI) private var chatGPTAPI
    private var gptGrettings: GPTGrettings {
        guard let modelIdentifier = UserDefaults.standard.string(forKey: "gptGrettings") else {
            return .default
        }
        return GPTGrettings(rawValue: modelIdentifier) ?? .default
    }

    @MainActor
    func getGreetingsFromChatGPT() async {
        chatGPTMessage = "..."
        let chatQuery = ChatQuery(model: GPTModel.gpt4Turbo.rawValue, messages: [
            Chat(role: .system, content: gptGrettings.systemPrompt),
            Chat(role: .user, content: gptGrettings.userPrompt),
        ])
        let newMessage = try? await chatGPTAPI.chats(query: chatQuery)
        let content = newMessage?.choices.first?.message.content?.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        chatGPTMessage = content ?? "..."
    }

    func createNewChatList() -> String? {
        let chatSidebar = ChatSidebar(name: "Nuevo chat " + "\(sidebarList.count + 1)")
        do {
            try sidebarStorage.save(chatSidebar)
            sidebarList.insert(chatSidebar, at: 0)
            return chatSidebar.id
        } catch {
            return nil
        }
    }

    func saveChatListName(sidebarChat: ChatSidebar?) {
        guard let sidebarChat else { return }
        do {
            try sidebarStorage.update(sidebarChat)
        } catch {
            print("--- Error saving chat list: \(error)")
        }
    }

    func deleteChatList(sidebarChat: ChatSidebar?) {
        guard let sidebarChat else { return }
        do {
            try sidebarStorage.delete(sidebarChat)
            sidebarList.removeAll { $0.id == sidebarChat.id }
        } catch {
            print("--- Error deleting chat list: \(error)")
        }
    }

    func getSidebarList() {
        sidebarList = sidebarStorage.fetchAll()
    }
}
