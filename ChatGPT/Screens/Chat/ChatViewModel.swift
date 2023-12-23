//
//  ChatViewModel.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 09-04-23.
//

import Factory
import OpenAI
import SwiftUI
import Tiktoken

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var gptPersonalities: [GPTPersonality] = []
    @Published private(set) var isSpeaking: Bool = false
    @Published private(set) var isLoadingChat = true
    @Published private(set) var errorOcurred = false
    @Injected(\.storageChat) private var chatStorage
    @Injected(\.storageGPTPersonality) private var personalityStorage
    @Injected(\.chatGPTRepository) private var chatGPTRepository
    @Injected(\.speakService) private var speakService
    private let chatSidebar: ChatSidebar
    private let isListReversed: Bool
    private(set) var emptyImages: String = Constants.chatViewImages.randomElement() ?? "sun.max.fill"

    #if os(iOS)
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    #else
    var tableView: NSTableView?
    #endif
    var chatTitle: String {
        chatSidebar.name
    }

    init(chatSidebar: ChatSidebar, isListReversed: Bool) {
        self.chatSidebar = chatSidebar
        self.isListReversed = isListReversed
        speakService.isSpeaking.assign(to: &$isSpeaking)
    }

    // MARK: Public methods

    func sendMessage(content: String) async {
        do {
            #if os(iOS)
            backgroundTask = UIApplication.shared.beginBackgroundTask {
                self.finishBackgroundTask()
            }
            #endif
            prepareChatQuery(message: content)
            var responseText = ""
            var lineIndex = 0
            let newMessageIndex = isListReversed ? 0 : messages.count - 1
            let chatStream = await chatGPTRepository.getChatStream(message: content)

            for try await message in chatStream {
                responseText += message
                if lineIndex < 100 || (lineIndex % 30) == 0 {
                    messages[newMessageIndex].content = responseText
                    lineIndex += 1
                } else {
                    lineIndex += 1
                }
            }
            messages[newMessageIndex].content = responseText
            chatGPTRepository.setLastGPTReply(content: responseText)
            saveLastMessagesInStorage()
        } catch {
            #if os(iOS)
            processError(error)
            #endif
            errorOcurred = true
            print("--- Error sending the message: \(error)")
        }
        #if os(iOS)
        finishBackgroundTask()
        #endif
    }

    func retrySendMessage() async {
        do {
            #if os(iOS)
            backgroundTask = UIApplication.shared.beginBackgroundTask {
                self.finishBackgroundTask()
            }
            #endif
            var responseText = ""
            var lineIndex = 0
            let newMessageIndex = isListReversed ? 0 : messages.count - 1
            let chatStream = await chatGPTRepository.retryGetChatStream()

            for try await message in chatStream {
                responseText += message
                if lineIndex < 100 || (lineIndex % 30) == 0 {
                    messages[newMessageIndex].content = responseText
                    lineIndex += 1
                } else {
                    lineIndex += 1
                }
            }
            messages[newMessageIndex].content = responseText
            chatGPTRepository.setLastGPTReply(content: responseText)
            saveLastMessagesInStorage()
            errorOcurred = false
        } catch {
            #if os(iOS)
            processError(error)
            #endif
            errorOcurred = true
            print("--- error retrying message: \(error)")
        }
        #if os(iOS)
        finishBackgroundTask()
        #endif
    }

    func getGPTPersonalities() {
        var personalities = personalityStorage.fetchAll()
        personalities.sort { $0.createdAt > $1.createdAt }
        gptPersonalities = personalities
        if let firstPersonality = personalities.first {
            chatGPTRepository.setGPTPersonality(with: firstPersonality)
        }
    }

    func loadHistoryChat() async {
        try? await Task.sleep(nanoseconds: 1)
        let history = chatStorage.fetchAll(from: chatSidebar, reversed: isListReversed)
        messages = history
        chatGPTRepository.replaceHistoryList(with: isListReversed ? history.reversed() : history)
        isLoadingChat = false
    }

    func speakLastResponse() {
        guard let responseText = messages.last?.content, !responseText.isEmpty else {
            return
        }
        speakService.speakMessage(content: responseText)
    }

    func speakMessage(content: String) {
        speakService.speakMessage(content: content)
    }

    func stopSpeakingMessage() {
        speakService.stopSpeaking()
    }

    func setGPTPersonality(_ personality: GPTPersonality) {
        chatGPTRepository.setGPTPersonality(with: personality)
    }

    // MARK: Private methods

    private func prepareChatQuery(message: String) {
        let userMessage = ChatMessage(role: .user, content: message)
        let chatGPTMessage = ChatMessage(role: .assistant, content: "...")
        if isListReversed {
            messages.insert(userMessage, at: 0)
            messages.insert(chatGPTMessage, at: 0)
        } else {
            messages.append(userMessage)
            messages.append(chatGPTMessage)
        }
    }

    private func saveLastMessagesInStorage() {
        let newMessageIndex = isListReversed ? 0 : messages.count - 1
        try? chatStorage.save(messages[newMessageIndex], to: chatSidebar)
        try? chatStorage.save(messages[isListReversed ? 1 : newMessageIndex - 1], to: chatSidebar)
    }

    #if os(iOS)
    private func processError(_ error: Error) {
        switch error {
        case let apiError as APIErrorResponse:
            let alertSetup: AlertHelperSetup
            if apiError.error.code == OpenAIError.invalidApiKey.rawValue {
                alertSetup = AlertHelperSetup(type: .informative, title: "Ups", message: "El API key que configuraste parece estar incorrecto. \n Verifícalo y vuelve a intentarlo.")
            } else if apiError.error.code == OpenAIError.contextLengthExceeded.rawValue {
                alertSetup = AlertHelperSetup(type: .informative, title: "Ups", message: "La conversación es muy larga para GPT. Intenta cambiar a una versión más moderna o empieza un nuevo chat.")

            } else if apiError.error.code == OpenAIError.modelNotFound.rawValue {
                alertSetup = AlertHelperSetup(type: .informative, title: "Modelo no encontrado", message: "El modelo custom que ingresate no fue encontrado. Intenta corregirlo o intenta más tarde.")
            } else if apiError.error.type == OpenAIError.invalidRequestError.rawValue {
                alertSetup = AlertHelperSetup(type: .informative, title: "API Key no encontrada", message: "Tienes que tener configurado un API key para empezar a usar CrackGPT.")
            } else {
                alertSetup = AlertHelperSetup(type: .informative, title: "Ups", message: "Hubo un error. Inténtalo de nuevo.")
            }
            AlertHelper.shared.showAlert(setup: alertSetup)
        case let urlError as URLError:
            let alertSetup: AlertHelperSetup
            switch urlError.code {
            case .timedOut, .notConnectedToInternet:
                alertSetup = AlertHelperSetup(type: .informative, title: "Ups", message: "Parece que tienes problemas de Internet. Intenta revisar tu conexión.")
            default:
                alertSetup = AlertHelperSetup(type: .informative, title: "Ups", message: "Hubo un error. Inténtalo de nuevo.")
            }
            AlertHelper.shared.showAlert(setup: alertSetup)
        default:
            let alertSetup = AlertHelperSetup(type: .informative, title: "Ups", message: "Hubo un error. Inténtalo de nuevo.")
            AlertHelper.shared.showAlert(setup: alertSetup)
        }
    }
    #endif

    #if os(iOS)
    private func finishBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    #endif
}
