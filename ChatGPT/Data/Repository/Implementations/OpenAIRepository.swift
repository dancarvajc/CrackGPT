//
//  OpenAIRepository.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 16-07-23.
//

import Factory
import Foundation
import OpenAI
import Tiktoken

final class OpenAIRepository: ChatGPTRepositoryProtocol {
    @Injected(\.chatGPTAPI) private var chatGPTAPI
    private var history: [Chat] = []
    private var gptEncoder: Encoding?
    private var currentGPTPersonality: GPTPersonality = .default
    private var currentGPTModel: GPTModel {
        guard let modelIdentifier = UserDefaults.standard.string(forKey: "gptModel") else {
            return .default
        }
        return GPTModel(rawValue: modelIdentifier)
    }

    // MARK: Public methods

    func getChatStream(message: String) async -> AsyncThrowingStream<String, Error> {
        let query = await prepareChatQuery(message: message)
        let chatGPTStream: AsyncThrowingStream<ChatStreamResult, Error> = chatGPTAPI.chatsStream(query: query)
        let processedStream = chatGPTStream.map {
            let content = $0.choices.first?.delta.content ?? ""
            return content
        }
        return processedStream.eraseToAsyncThrowingStream()
    }

    func retryGetChatStream() async -> AsyncThrowingStream<String, Error> {
        let query = await prepareChatQueryWhenRetry()
        let chatGPTStream: AsyncThrowingStream<ChatStreamResult, Error> = chatGPTAPI.chatsStream(query: query)
        let processedStream = chatGPTStream.map {
            let content = $0.choices.first?.delta.content ?? ""
            return content
        }
        return processedStream.eraseToAsyncThrowingStream()
    }

    private func prepareChatQueryWhenRetry() async -> ChatQuery {
        if history.first?.role != .system {
            let systemChat = Chat(role: .system, content: currentGPTPersonality.description)
            history.insert(systemChat, at: 0)
        } else if history.first?.role == .system {
            let systemChat = Chat(role: .system, content: currentGPTPersonality.description)
            history[0] = systemChat
        }
        await verifyMaxTokens()
        let query = ChatQuery(model: currentGPTModel.rawValue, messages: history)
        return query
    }

    func setLastGPTReply(content: String) {
        let gptReply = Chat(role: .assistant, content: content)
        history.append(gptReply)
    }

    func setGPTPersonality(with personality: GPTPersonality) {
        currentGPTPersonality = personality
    }

    func replaceHistoryList(with history: [ChatMessage]) {
        self.history = history.mapToOpenAIModel()
    }

    // MARK: Private methods

    // Add and update system text accoding the current gpt personality and create the ChatQuery
    private func prepareChatQuery(message: String) async -> ChatQuery {
        if history.first?.role != .system {
            let systemChat = Chat(role: .system, content: currentGPTPersonality.description)
            history.insert(systemChat, at: 0)
        } else if history.first?.role == .system {
            let systemChat = Chat(role: .system, content: currentGPTPersonality.description)
            history[0] = systemChat
        }
        let userMessage = Chat(role: .user, content: message)
        history.append(userMessage)
        await verifyMaxTokens()
        let query = ChatQuery(model: currentGPTModel.rawValue, messages: history)
        return query
    }

    // MARK: Improve in the future

    private func verifyMaxTokens() async {
        if gptEncoder == nil {
            gptEncoder = try? await Tiktoken.shared.getEncoding(.gpt4)
        }
        while (gptEncoder?.encode(value: history.content).count ?? 0) > currentGPTModel.maxTokens {
            history.remove(at: 1)
        }
    }
}
